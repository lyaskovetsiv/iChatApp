//
//  PeopleViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import UIKit
import SnapKit

fileprivate typealias PeopleDataSource = UICollectionViewDiffableDataSource<PeopleVC.Section, MUser>
fileprivate typealias PeopleSnapShot = NSDiffableDataSourceSnapshot<PeopleVC.Section, MUser>

class PeopleVC: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: PeopleDataSource!
    
    private var users = [MUser(id: UUID(), userName: "John", userImage: nil),
                         MUser(id: UUID(), userName: "Peter", userImage: nil),
                         MUser(id: UUID(), userName: "Rebecca", userImage: nil),
                         MUser(id: UUID(), userName: "James", userImage: nil),
                         MUser(id: UUID(), userName: "Jessica", userImage: nil),
                         MUser(id: UUID(), userName: "Ivan", userImage: nil),
                         MUser(id: UUID(), userName: "Bonya", userImage: nil),
                         MUser(id: UUID(), userName: "Abraham", userImage: nil),
                         MUser(id: UUID(), userName: "Nelly", userImage: nil)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createDataSource()
        updateDataSorce()
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        title = "People"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearch()
        setupCollectionView()
        setupConstraits()
    }
    
    private func setupSearch(){
        let searchVC = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchVC
    }
    
    private func setupCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "userCell")
        view.addSubview(collectionView)
    }
}


//MARK: --Data Source
extension PeopleVC{
    
    private func createDataSource(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let section = PeopleVC.Section(rawValue: indexPath.section) else {fatalError("Unknown section")}
            switch section{
                case .main:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath)
                cell.backgroundColor = .red
                return cell
            }
        })
    }
    
    private func updateDataSorce(){
        var snapShot = PeopleSnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(users, toSection: .main)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}


//MARK: --Layout
extension PeopleVC{
    
    private func createLayout()->UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard let section = PeopleVC.Section(rawValue: sectionIndex) else {fatalError("Unknown section")}
            switch section{
                case .main:
                return self.createSection()
            }
        }
        return layout
    }
    
    private func createSection()-> NSCollectionLayoutSection{
        
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.6), item: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return section
    }
}


//MARK: --Constraits
extension PeopleVC{
    
    private func setupConstraits(){
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}


//MARK: --Enums
extension PeopleVC{
    fileprivate enum Section: Int{
        case main
    }
}
