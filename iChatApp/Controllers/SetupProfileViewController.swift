//
//  RegisterViewController.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import UIKit
import SnapKit

class SetupProfileViewController: UIViewController {
    
    //MARK: --Properties
    private let welcomeLabel = UILabel(text: "Set up profile", font: .avenit26())
    private let photoUserView = AddPhotoView()
    private let fullNameLabel = UILabel(text: "Full name")
    private let fullNameTextField = UITextField(placeholderText: "Enter your full name")
    private let aboutLabel = UILabel(text: "About me")
    private let aboutTextField = UITextField(placeholderText: "Enter addition info about yourself")
    private let sexLabel  = UILabel(text: "Sex")
    private let sexControll = UISegmentedControl(first: "Male", second: "Female")
    private let goChattingButton = UIButton(title: "Go to charts!", titleColor: .white, backgroundColor: .black)
    private var mainStackView: UIStackView!
    //TODO: Error label
    
    
    //MARK: --LifeCycleOfViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: --Functions
    private func setupView(){
        view.backgroundColor = .systemBackground
        
        let fullNameView = TextFieldFormView(label: fullNameLabel, textField: fullNameTextField)
        let aboutView = TextFieldFormView(label: aboutLabel, textField: aboutTextField)
        let sexView = SegmentedFormView(label: sexLabel, segmentedControl: sexControll)
        mainStackView = UIStackView(arrangedView: [fullNameView, aboutView, sexView, goChattingButton], spacing: 40, axis: .vertical)
        
        view.addSubview(welcomeLabel)
        view.addSubview(photoUserView)
        view.addSubview(mainStackView)

        setupConstraits()
    }
}


//MARK: --Constraits
extension SetupProfileViewController{
    
    private func setupConstraits(){
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(140)
        }
        
        photoUserView.translatesAutoresizingMaskIntoConstraints = false
        photoUserView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(welcomeLabel.snp.bottom).inset(-40)
        }
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(60)
            make.left.equalTo(view.snp.left).inset(40)
            make.right.equalTo(view.snp.right).inset(40)
        }
        
        goChattingButton.translatesAutoresizingMaskIntoConstraints = false
        goChattingButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
}


//MARK: CANVAS mode
import SwiftUI

struct RegisterViewControllerProvider: PreviewProvider{
    
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable{
       
        let viewController = SetupProfileViewController()
        
        func makeUIViewController(context: Context) -> SetupProfileViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
