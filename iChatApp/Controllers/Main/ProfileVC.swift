//
//  ProfileVC.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 20.10.2022.
//

import UIKit
import SnapKit
import SDWebImage

class ProfileVC: UIViewController {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel(text: "", font: .systemFont(ofSize: 24, weight: .regular))
    private let aboutMeLabel = UILabel(text: "", font: .systemFont(ofSize: 18, weight: .light))
    private let textField = InsertableTextField()
    private var stackView: UIStackView!
    
    private let user: MUser!
    
    init(user: MUser){
        self.user = user
        self.nameLabel.text = user.userName
        self.aboutMeLabel.text = user.description
        self.imageView.image = nil
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView(){
        view.addSubview(imageView)
        view.addSubview(containerView)
        setupContainerView()
        setupConstraits()
        imageView.sd_setImage(with: URL(string: user.userImageUrl), completed: nil)
    }
    
    private func setupContainerView(){
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(textField)
    }
    
    @objc private func sendMessage(){
        guard let message = textField.text, textField.text != "" else { return }
        self.dismiss(animated: true) {
            FirestoreService.shared.createWaitingChat(message: message, reciever: self.user) { result in
                switch result{
                    case .success():
                    UIApplication.getTopViewController()?.showAlert(title: "Success", message: "You message was send to \(self.user.userName)")
                case .failure(let error):
                    UIApplication.getTopViewController()?.showAlert(title: "Error", message: "Unknown error. You can't send message to this person")
                }
            }
        }
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
        
        if let button = textField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
        
    }
    
}


