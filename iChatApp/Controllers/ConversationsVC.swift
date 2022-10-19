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
    
    private let activeChats = [MChat(userName: "Aleksey", lastMessage: "How are you?"),
                               MChat(userName: "Nina", lastMessage: "So funny)"),
                               MChat(userName: "John", lastMessage: "Let's go!"),
                               MChat(userName: "Rebecca", lastMessage: "Are you hungry?") ]
    
    private let waitingChats = [MChat(userName: "Aleksey", lastMessage: "How are you?"),
                               MChat(userName: "Nina", lastMessage: "So funny)"),
                               MChat(userName: "John", lastMessage: "Let's go!"),
                               MChat(userName: "Rebecca", lastMessage: "Are you hungry?"),
                               MChat(userName: "Rebecca", lastMessage: "Are you hungry?"),
                               MChat(userName: "Rebecca", lastMessage: "Are you hungry?") ]
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDataSource()
        updateDataSource()
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Conversations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutTapped))
        setupCollectionView()
        setupConstraits()
    }
    
    private func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseIdentifier)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    @objc private func logOutTapped(){
        print("Log out..")
    }
    
}

//MARK: --DataSource
extension ConversationsVC{
    
    private func setupDataSource(){
        dataSource = ChatDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section")}
            switch section {
                case .activeChats:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActiveChatCell.reuseIdentifier, for: indexPath) as! ActiveChatCell
                    return cell
                case .waitingChats:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitingChatCell.reuseIdentifier, for: indexPath) as! WaitingChatCell
                    return cell
            }
        })
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
            guard let section = Section(rawValue: sectionIndex) else {fatalError("Unknown section")}
            switch section{
                case .activeChats:
                    return self.createActiveChats()
                case .waitingChats:
                    return self.createIncommingChats()
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
        return section
    }
    
    private func createIncommingChats()->NSCollectionLayoutSection{
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 5)
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.15), item: item, count: 4)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}


//MARK: --SetupConstraits
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
    }
}






