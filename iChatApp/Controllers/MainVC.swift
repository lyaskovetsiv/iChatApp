//
//  TabBarController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import UIKit

class MainVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .label
        
        let peopleVC = PeopleVC()
        let conversationsVC = ConversationsVC()
        let peopleImage = UIImage(systemName: "person.2")
        let conversationImage = UIImage(systemName: "message")
        
        let firstVC = createNavigationController(rootViewController: peopleVC, title: "People", image: peopleImage)
        let secondVC = createNavigationController(rootViewController: conversationsVC, title: "Conversations", image: conversationImage)

        viewControllers = [firstVC, secondVC]
    }
    
    private func createNavigationController(rootViewController: UIViewController, title: String, image: UIImage?)->UIViewController{
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }

}
