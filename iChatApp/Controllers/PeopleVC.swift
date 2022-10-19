//
//  PeopleViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import UIKit

class PeopleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        
        setupSearch()
    }
    
    private func setupSearch(){
        let searchVC = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchVC
    }
    
}
