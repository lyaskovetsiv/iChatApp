//
//  ViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 10.10.2022.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {
    
    private let logoImageView = UIImageView(with: UIImage(named: "logo"), contentMode: .scaleAspectFit)
    private let googleLabel = UILabel(text: "Get started with ")
    private let emailLabel = UILabel(text: "Or sign with ")
    private let loginLabel = UILabel(text: "Already on board? ")
    private let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, shadows: true)
    private let emailButton = UIButton(title: "Email", titleColor: .black, backgroundColor: .white, shadows: true)
    private let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .black, shadows: false)
    private let loginVC = LoginViewController()
    private let signUpVC = SignUpViewController()
    private var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        loginVC.delegate = self
        signUpVC.delegate = self
    }
    
    private func setupView(){
        
        view.backgroundColor = .systemBackground
        
        googleButton.customizeGoogleImage()
        emailButton.addTarget(self, action: #selector(emailBtnTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleBtnTapped), for: .touchUpInside)
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: loginLabel, button: loginButton)
        stackView = UIStackView(arrangedView: [googleView, emailView, loginView], spacing: 30, axis: .vertical)
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        setupConstraits()
    }
    
    @objc private func emailBtnTapped(){
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    @objc private func loginBtnTapped(){
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @objc private func googleBtnTapped(){
        
    }
    
}


//MARK: --AuthNavigationDelegate
extension AuthViewController: AuthNavigationDelegate{
    
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }

}


//MARK: --Constraits
extension AuthViewController{
    
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
            make.right.equalTo(view.snp.right).inset(40)
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


