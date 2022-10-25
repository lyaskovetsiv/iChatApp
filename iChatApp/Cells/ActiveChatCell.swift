//
//  ActiveChatCell.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import UIKit
import SnapKit

class ActiveChatCell: UICollectionViewCell, ConfiguringCell {
    
    static let reuseIdentifier = "activeChatCell"
    
    let userImageView = UIImageView()
    let userName = UILabel(text: "", font: .laoSangamMN20())
    let userLastMessage = UILabel(text: "", font: .laoSangamMN18())
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        addSubview(userImageView)
        addSubview(stackView)
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell(){
        backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        userImageView.backgroundColor = .systemGray
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        stackView = UIStackView(arrangedView: [userName,userLastMessage], spacing: 5, axis: .vertical)
    }
    

    func configure<U>(with value: U) where U : Hashable {
        guard let chat = value as? MChat else {fatalError("Unkown kind of data")}
        userImageView.image = chat.userImage
        userName.text = chat.userName
        userLastMessage.text = chat.lastMessage
        
    }
}


//MARK: --Constraits
extension ActiveChatCell{
    
    private func setupConstraits(){
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.height.equalTo(85)
            make.width.equalTo(85)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(userImageView.snp.right).inset(-20)
        }
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor)
        ])
    }
}
