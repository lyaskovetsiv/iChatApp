//
//  UserCell.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 24.10.2022.
//

import UIKit
import SnapKit

class UserCell: UICollectionViewCell, ConfiguringCell {

    static let reuseIdentifier = "userCell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupContainerView()
        addSubview(containerView)
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView(){
        addSubview(imageView)
        addSubview(nameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 5
    }
    
    private func setupCell(){
        backgroundColor = .systemBackground
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user = value as? MUser else {fatalError("Unknown kind of data")}
        imageView.image = user.userImage
        nameLabel.text = user.userName
    }
}


//MARK: --Constraits
extension UserCell{
    
    private func setupConstraits(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.left.equalTo(containerView.snp.left)
            make.right.equalTo(containerView.snp.right)
            make.height.equalTo(containerView.snp.width)
        }
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(containerView.snp.left).inset(10)
            make.right.equalTo(containerView.snp.right).inset(10)
            make.top.equalTo(imageView.snp.bottom).inset(-10)
        }
    }
}

