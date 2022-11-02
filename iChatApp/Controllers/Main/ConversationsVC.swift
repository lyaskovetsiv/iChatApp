//
//  ConversationsViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

fileprivate typealias ChatDataSource = UICollectionViewDiffableDataSource<ConversationsVC.Section, MChat>
fileprivate typealias ChatSnapShot = NSDiffableDataSourceSnapshot<ConversationsVC.Section, MChat>

class ConversationsVC: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: ChatDataSource!
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    private var activeChats = [MChat]()
    private var waitingChats = [MChat]()
    private let currentUser: MUser!

    init(with currentUser: MUser){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        waitingChatsListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createDataSource()
        updateDataSource()
        setupListeners()
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        navigationItem.title = currentUser.userName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutTapped))
        setupCollectionView()
        setupConstraits()
    }
    
    private func setupListeners(){
        
        waitingChatsListener = ListenerService.shared.chatsObserve(chats: waitingChats, kindofChat: "waitingChats", completionBlock: { result in
            switch result{
                case .success(let mChats):
                    if !self.waitingChats.isEmpty, self.waitingChats.count <= mChats.count {
                        let chatRequestVC = ChatRequestVC(chat: mChats.last!)
                        self.present(chatRequestVC, animated: true, completion: nil)
                    }
                    self.waitingChats = mChats
                    self.updateDataSource()
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
        
        activeChatsListener = ListenerService.shared.chatsObserve(chats: activeChats, kindofChat: "activeChats", completionBlock: { result in
            switch result{
                case .success(let chats):
                    self.activeChats = chats
                    self.updateDataSource()
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    private func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseIdentifier)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    @objc private func logOutTapped(){
        let vc = UIAlertController(title: "Quit?", message: "Do you really want to sign out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .destructive, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
            do{
                try Auth.auth().signOut()
                self.view.window?.rootViewController = AuthViewController()
                self.view.window?.makeKeyAndVisible()
            }
            catch{
                print("Can't sign out: \(error.localizedDescription)")
            }
        }
        vc.addAction(okAction)
        vc.addAction(cancelAction)
        self.present(vc, animated: true, completion: nil)
    }
    
}


//MARK: --UICollectionViewDelegate
extension ConversationsVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource.itemIdentifier(for: indexPath) else {return}
        guard let section = ConversationsVC.Section(rawValue: indexPath.section) else {return}
        switch section{
            case .waitingChats:
                let vc = ChatRequestVC(chat: chat)
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            case .activeChats:
                let vc = ChatVC(currentUser: currentUser, chat: chat)
                navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK: --ConvNavigationDelegate
extension ConversationsVC: ConvNavigationDelegate{
    
    func removeWaitingChat(chat: MChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { result in
            switch result{
                case .success():
                    self.showAlert(title: "Success", message: "Chat with \(chat.friendUserName) was deleted")
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func changeToActive(chat: MChat) {
        FirestoreService.shared.changeChatToActive(chat: chat) { result in
            switch result{
            case .success():
                self.showAlert(title: "Success", message: "Good chatting with \(chat.friendUserName)!")
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}


//MARK: --DataSource
extension ConversationsVC{
    
    private func createDataSource(){
        dataSource = ChatDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let section = ConversationsVC.Section(rawValue: indexPath.section) else { fatalError("Unknown section")}
            switch section {
                case .activeChats:
                    return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: model, for: indexPath)
                case .waitingChats:
                    return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: model, for: indexPath)
            }
        })
        
        dataSource.supplementaryViewProvider = {
            collectionView, elementKind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {fatalError("Can't create new section header")}
            guard let section = ConversationsVC.Section(rawValue: indexPath.section) else {fatalError("Unknown section")}
            sectionHeader.configure(with: section.description(), font: .laoSangamMN20()!, textColor: .systemGray)
            return sectionHeader
        }
    }
    
    private func updateDataSource(){
        var snapShot = ChatSnapShot()
        snapShot.appendSections([.waitingChats, .activeChats])
        snapShot.appendItems(waitingChats, toSection: .waitingChats)
        snapShot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
}


//MARK: --Layout
extension ConversationsVC{
    
    private func createLayout()->UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard let section = ConversationsVC.Section(rawValue: sectionIndex) else {fatalError("Unknown section")}
            switch section{
                case .activeChats:
                    return self.createActiveChats()
                case .waitingChats:
                    return self.createWaitingChats()
            }
        }
        return layout
    }
    
    private func createActiveChats()->NSCollectionLayoutSection{
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
        let group = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .absolute(85), item: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createWaitingChats()->NSCollectionLayoutSection{
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 5)
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.25), item: item, count: 4)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader()->NSCollectionLayoutBoundarySupplementaryItem{
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        return sectionHeader
    }

}


//MARK: --Constraits
extension ConversationsVC{
    private func setupConstraits(){
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}


//MARK: --SectionLogic
extension ConversationsVC{
    
    fileprivate enum Section: Int{
        case waitingChats
        case activeChats
        
        func description()->String{
            switch self{
            case .waitingChats:
                return "Waiting Chats"
            case .activeChats:
                return "Active Chats"
            }
        }
    }
}

