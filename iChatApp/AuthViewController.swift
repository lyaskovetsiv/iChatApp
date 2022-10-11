//
//  ViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 10.10.2022.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {
    
    //MARK: --Properties
    private let logoImageView = UIImageView(with: UIImage(named: "logo"), contentMode: .scaleAspectFit)
    
    private let googleLabel = UILabel(text: "Get started with ")
    private let emailLabel = UILabel(text: "Or sign with ")
    private let loginLabel = UILabel(text: "Already on board? ")

    private let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, shadows: true)
    private let emailButton = UIButton(title: "Email", titleColor: .black, backgroundColor: .white, shadows: true)
    private let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .black, shadows: false)
    private var stackView: UIStackView!
    
    
    //MARK: --LifeCycleOfViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupView()
    }
    
    
    //MARK: --Functions
    private func setupView(){
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: loginLabel, button: loginButton)
        stackView = UIStackView(arrangedView: [googleView, emailView, loginView], spacing: 30, axis: .vertical)
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        setupConstraits()
    }
    
    private func setupConstraits(){
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(140)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(180)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).inset(-50)
            make.centerX.equalTo(view.snp.centerX)
            make.left.equalTo(view.snp.left).inset(40)
            make.right.equalTo(view.snp.right).inset(50)
        }
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


