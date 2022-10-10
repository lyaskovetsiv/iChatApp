//
//  ViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 10.10.2022.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {
    
    let imageView = UIImageView(with: UIImage(named: "logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with ")
    let emailLabel = UILabel(text: "Or sign with ")
    let onBoardLabel = UILabel(text: "Already on board? ")

    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white)
    let emailButton = UIButton(title: "Email", titleColor: .black, backgroundColor: .buttonBlack())
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupView()
    }
    
    private func setupView(){
        setupConstraits()
    }
    
    private func setupConstraits(){
        
    }
    
}



//MARK: CANVAS mode
import SwiftUI

struct AuthViewControllerProvider: PreviewProvider{
    
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable{
       
        let viewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> AuthViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}


