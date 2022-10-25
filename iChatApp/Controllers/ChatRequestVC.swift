//
//  ChatRequestVC.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 20.10.2022.
//

import UIKit
import SnapKit

class ChatRequestVC: UIViewController {
    
    private let imageView = UIImageView()
    private let containerView = UIView()
    private let nameLabel = UILabel(text: "Helen Brenson", font: .systemFont(ofSize: 24, weight: .regular), textColor: nil)
    private let systemLabel = UILabel(text: "You have an opportunity to start a new chat!", font: .systemFont(ofSize: 18, weight: .light), textColor: nil)
    private let acceptButton = UIButton(title: "ACCEPT", titleColor: .systemGreen, backgroundColor: .white, cornerRadius: 10, shadows: false)
    private let denyButton = UIButton(title: "DENY", titleColor: .systemRed, backgroundColor: .white, cornerRadius: 10, shadows: false)
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
        stackView = UIStackView(arrangedView: [acceptButton, denyButton], spacing: 15, axis: .horizontal)
        containerView.addSubview(nameLabel)
        containerView.addSubview(systemLabel)
        containerView.addSubview(stackView)
    }
}


//MARK: --Constaits
extension ChatRequestVC{
    
    private func setupConstraits(){
        setupElements()
        
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
            make.top.equalTo(containerView.snp.top).inset(30)
            make.left.equalTo(containerView.snp.left).inset(20)
            make.right.equalTo(containerView.snp.right).inset(20)
        }
        
        systemLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(-10)
            make.left.equalTo(containerView.snp.left).inset(20)
            make.right.equalTo(containerView.snp.right).inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(systemLabel.snp.bottom).inset(-20)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        denyButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
    }
    
    private func setupElements(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        systemLabel.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        denyButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "girl")
        imageView.contentMode = .scaleAspectFill
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
        
        stackView.distribution = .equalSpacing

        acceptButton.layer.borderColor = UIColor.systemGreen.cgColor
        acceptButton.layer.borderWidth = 3

        denyButton.layer.borderColor = UIColor.systemRed.cgColor
        denyButton.layer.borderWidth = 3
    }
}


//MARK: --Canvas
import SwiftUI

struct ChatRequestVCProvider: PreviewProvider{
    
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable{
        
        let viewController = ChatRequestVC()
        
        func makeUIViewController(context: Context) -> ChatRequestVC {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
