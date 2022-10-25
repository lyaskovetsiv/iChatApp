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
        updateDataSorce(with: nil)
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
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
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
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
                    return self.configure(collectionView: collectionView, cellType: UserCell.self, with: model, for: indexPath)
            }
        })
        
        dataSource.supplementaryViewProvider = {
            collectionView, elementKind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {fatalError("Can't create section header")}
            guard let section = PeopleVC.Section(rawValue: indexPath.section) else {fatalError("Unknown section")}
            
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: section)
            sectionHeader.configure(with: section.description(usersCount: items.count), font: .systemFont(ofSize: 36, weight: .light), textColor: .label)
            return sectionHeader
        }
    }
    
    private func updateDataSorce(with searchText: String?){
        
        let filteredUsers = users.filter { user in
            user.contains(text: searchText)
        }
        var snapShot = PeopleSnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(filteredUsers, toSection: .main)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}


extension PeopleVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateDataSorce(with: searchText)
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
        
        func description(usersCount: Int)->String{
            switch self{
            case .main:
                return "\(usersCount) people nearby"
            }
        }
    }
}


//MARK: --Canvas
import SwiftUI

struct PeopleVCProvider: PreviewProvider{
    
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable{
        
        let viewController = PeopleVC()
        
        func makeUIViewController(context: Context) -> PeopleVC {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
