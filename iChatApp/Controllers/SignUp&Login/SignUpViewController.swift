//
//  SignUpViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 11.10.2022.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {

    private let welcomeLabel = UILabel(text: "Good to see you!", font: .avenit26())
    private let emailLabel = UILabel(text: "Email")
    private let emailTextField = UITextField(placeholderText: "Enter your email")
    private let passwordLabel = UILabel(text: "Password")
    private let passwordTextField = UITextField(placeholderText: "Enter your password")
    private let repassLabel = UILabel(text: "Confirm password")
    private let repassTextField = UITextField(placeholderText: "Enter you password again")
    private let signUpButton = UIButton(title: "SignUp", titleColor: .white, backgroundColor: .black, shadows: false)
    private var mainStackView: UIStackView!
    private let onBoardLabel = UILabel(text: "Already onboard?")
    private let loginButton = UIButton(title: "Login", titleColor: .red, backgroundColor: .systemBackground, shadows: false)
    private var footStackView: UIStackView!
    weak var delegate: AuthNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        
        view.backgroundColor = .systemBackground
        
        signUpButton.addTarget(self, action: #selector(signUpBtnTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        
        let emailView = TextFieldFormView(label: emailLabel, textField: emailTextField)
        let passwordView = TextFieldFormView(label: passwordLabel, textField: passwordTextField)
        let repasswordView = TextFieldFormView(label: repassLabel, textField: repassTextField)
        
        mainStackView = UIStackView(arrangedView: [emailView, passwordView, repasswordView, signUpButton], spacing: 40, axis: .vertical)
        footStackView = UIStackView(arrangedView: [onBoardLabel, loginButton], spacing: 5, axis: .horizontal)
        
        view.addSubview(welcomeLabel)
        view.addSubview(mainStackView)
        view.addSubview(footStackView)
        
        setupConstraits()
    }
    
    @objc private func signUpBtnTapped(){
        
        AuthService.shared.createUser(email: emailTextField.text, password: passwordTextField.text, confirmPassword: repassTextField.text) { result in
            switch result{
                case .success(let user):
                self.showAlert(title: "Success", message: "You've been successfully signed up!") {
                    self.present(SetupProfileViewController(with: user), animated: true, completion: nil)
                }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    print(error)
                
            }
        }
    }
    
    @objc private func loginBtnTapped(){
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
    
    
}

//MARK: --Constraits
extension SignUpViewController{
    
    private func setupConstraits(){
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(140)
        }
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(welcomeLabel.snp.bottom).inset(-80)
            make.left.equalTo(view.snp.left).inset(40)
            make.right.equalTo(view.snp.right).inset(40)
        }
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        footStackView.translatesAutoresizingMaskIntoConstraints = false
        footStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
            make.left.equalTo(view.snp.left).inset(40)
        }
    }
}


//MARK: CANVAS mode
import SwiftUI

struct SignUpViewControllerProvider: PreviewProvider{
    
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable{
       
        let viewController = SignUpViewController()
        
        func makeUIViewController(context: Context) -> SignUpViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
