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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        addSubview(imageView)
        addSubview(nameLabel)
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(self.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).inset(10)
            make.right.equalTo(self.snp.right).inset(10)
            make.top.equalTo(imageView.snp.bottom).inset(-10)
        }
    }
}

