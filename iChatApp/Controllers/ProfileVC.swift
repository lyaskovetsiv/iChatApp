//
//  ProfileVC.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 20.10.2022.
//

import UIKit
import SnapKit

class ProfileVC: UIViewController {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel(text: "Peter Ben", font: .systemFont(ofSize: 20, weight: .regular))
    private let aboutMeLabel = UILabel(text: "You have an opportunity with the best in the world!", font: .systemFont(ofSize: 16, weight: .light))
    private let textField = UITextField()
    private var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        view.addSubview(imageView)
        view.addSubview(containerView)
        setupContainerView()
        setupConstraits()
    }
    
    private func setupContainerView(){
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(textField)
    }

}

//MARK: --Constraits
extension ProfileVC{
    
    private func setupConstraits(){
        customizeElements()
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(containerView.snp.top).inset(30)
        }
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(200)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).inset(35)
            make.left.equalTo(containerView.snp.left).inset(20)
            make.right.equalTo(containerView.snp.right).inset(20)
        }
        
        aboutMeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(-5)
            make.left.equalTo(containerView.snp.left).inset(20)
            make.right.equalTo(containerView.snp.right).inset(20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(aboutMeLabel.snp.bottom).inset(-10)
            make.left.equalTo(containerView.snp.left).inset(20)
            make.right.equalTo(containerView.snp.right).inset(20)
            make.height.equalTo(40)
        }
    }
    
    private func customizeElements(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "man")
        imageView.contentMode = .scaleAspectFill
        
        containerView.backgroundColor = UIColor.init(red: 245, green: 245, blue: 245, alpha: 1)
        containerView.layer.cornerRadius = 30
        
        aboutMeLabel.numberOfLines = 0
        
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Say hello to this person.."
    }
}



//MARK: --Canvas
import SwiftUI

struct ViewControllerProvider: PreviewProvider{
    
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable{
        
        let viewController = ProfileVC()
        
        func makeUIViewController(context: Context) -> ProfileVC {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
    
}
