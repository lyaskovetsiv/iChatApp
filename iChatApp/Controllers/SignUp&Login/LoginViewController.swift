//
//  LoginViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 12.10.2022.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    private let welcomeLabel = UILabel(text: "Welcome back!", font: .avenit26())
    private let orLabel = UILabel(text: "or")
    private let googleLabel = UILabel(text: "Login with")
    private let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, shadows: true)
    private let emailLabel = UILabel(text: "Email")
    private let emailTextField = UITextField(placeholderText: "Enter your email")
    private let passwordLabel = UILabel(text: "Password")
    private let passwordTextField = UITextField(placeholderText: "Enter your password")
    private let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .black)
    private let signUpLabel = UILabel(text: "Need an account?")
    private let signUpButton = UIButton(title: "Sign Up", titleColor: .red, backgroundColor: .systemBackground)
    private var mainStackView: UIStackView!
    private var bottomStackView: UIStackView!
    
    weak var delegate: AuthNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        
        view.backgroundColor = .systemBackground
    
        loginButton.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpBtnTapped), for: .touchUpInside)
        
        googleButton.isEnabled = false
        googleButton.customizeGoogleImage()
        //googleButton.addTarget(self, action: #selector(googleBtnTapped), for: .touchUpInside)
        
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
    
//    @objc private func googleBtnTapped(){
//        
//    }
    
    @objc private func loginBtnTapped(){
        AuthService.shared.loginIn(email: emailTextField.text, password: passwordTextField.text) { result in
            switch result{
                case .success(let user):
                    self.showAlert(title: "Success", message: "You have been successfully logIn")
                    FirestoreService.shared.getUser(user: user) { result in
                        switch result{
                        case .success(let mUser):
                            let mainVC = MainVC(with: mUser)
                            mainVC.modalPresentationStyle = .fullScreen
                            self.present(mainVC, animated: true, completion: nil)
                        case .failure(_):
                            //TODO: Может быть через презент?
                            self.view.window?.rootViewController = SetupProfileViewController(with: user)
                            self.view.window?.makeKeyAndVisible()
                        }
                    }
                
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    print(error)
            }
        }
    }
    
    @objc private func signUpBtnTapped(){
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
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



