//
//  LoginViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 12.10.2022.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    //MARK: --Properties
    let welcomeLabel = UILabel(text: "Welcome back!", font: .avenit26())
    let orLabel = UILabel(text: "or")
    let googleLabel = UILabel(text: "Login with")
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, shadows: true)
    let emailLabel = UILabel(text: "Email")
    let emailTextField = UITextField(placeholderText: "Enter your email")
    let passwordLabel = UILabel(text: "Password")
    let passwordTextField = UITextField(placeholderText: "Enter your password")
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .black)
    let signUpLabel = UILabel(text: "Need an account?")
    let signUpButton = UIButton(title: "Sign Up", titleColor: .red, backgroundColor: .systemBackground)
    
    var mainStackView: UIStackView!
    var bottomStackView: UIStackView!
    
    
    //MARK: --LifeCycleOfViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: --Functions
    private func setupView(){
        
        view.backgroundColor = .systemBackground
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = TextFieldFormView(label: emailLabel, textField: emailTextField)
        let passwordView = TextFieldFormView(label: passwordLabel, textField: passwordTextField)
        mainStackView = UIStackView(arrangedView: [googleView, orLabel, emailView, passwordView, loginButton], spacing: 40, axis: .vertical)
        bottomStackView = UIStackView(arrangedView: [signUpLabel, signUpButton], spacing: 5, axis: .horizontal)
        
        view.addSubview(welcomeLabel)
        view.addSubview(mainStackView)
        view.addSubview(bottomStackView)
        
        setupConstraits()
    }
    
}

//MARK: --Constraits
extension LoginViewController{
    
    private func setupConstraits(){
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(100)
        }
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(welcomeLabel.snp.bottom).inset(-80)
            make.left.equalTo(view.snp.left).inset(40)
            make.right.equalTo(view.snp.right).inset(40)
        }
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
            make.left.equalTo(view).inset(40)
        }
    }
}


//MARK: CANVAS mode
import SwiftUI

struct LoginViewControllerProvider: PreviewProvider{
    
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable{
       
        let viewController = LoginViewController()
        
        func makeUIViewController(context: Context) ->LoginViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}



