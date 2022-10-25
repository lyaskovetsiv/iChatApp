//
//  ConversationsViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import UIKit
import SnapKit

fileprivate typealias ChatDataSource = UICollectionViewDiffableDataSource<ConversationsVC.Section, MChat>
fileprivate typealias ChatSnapShot = NSDiffableDataSourceSnapshot<ConversationsVC.Section, MChat>

class ConversationsVC: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: ChatDataSource!
    
    private let activeChats = [MChat(userName: "Aleksey", userImage: UIImage(named: "man"), lastMessage: "How are you?"),
                               MChat(userName: "Nina", userImage: UIImage(named: "girl"),  lastMessage: "So funny)"),
                               MChat(userName: "John", userImage: UIImage(named: "man"),  lastMessage: "Let's go!"),
                               MChat(userName: "Rebecca", userImage: UIImage(named: "girl"),  lastMessage: "Are you hungry?")
    ]
    
    private let waitingChats = [MChat(userName: "Aleksey", userImage: UIImage(named: "man"),  lastMessage: "How are you?"),
                               MChat(userName: "Nina", userImage: UIImage(named: "girl"),  lastMessage: "So funny)"),
                               MChat(userName: "John", userImage: UIImage(named: "man"),  lastMessage: "Let's go!"),
                               MChat(userName: "Rebecca", userImage: UIImage(named: "girl"),  lastMessage: "Are you hungry?")
    ]
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createDataSource()
        updateDataSource()
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutTapped))
        setupCollectionView()
        setupConstraits()
    }
    
    private func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseIdentifier)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    @objc private func logOutTapped(){
        print("Log out..")
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


//MARK: --Enums
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


//MARK: --Canvas
import SwiftUI

struct ConversationsVCProvider: PreviewProvider{
    
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable{
        
        let viewController = ConversationsVC()
        
        func makeUIViewController(context: Context) -> ConversationsVC {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}



