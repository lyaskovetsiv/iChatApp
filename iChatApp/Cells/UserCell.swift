//
//  UserCell.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 24.10.2022.
//

import UIKit
import SnapKit
import SDWebImage

class UserCell: UICollectionViewCell, ConfiguringCell {

    static let reuseIdentifier = "userCell"
    
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
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
    
    private func setupCell(){
        backgroundColor = .systemBackground
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    }
    
    private func setupContainerView(){
        addSubview(userImageView)
        addSubview(userNameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        userImageView.image = nil
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user = value as? MUser else {fatalError("Unknown kind of data")}
        guard let url = URL(string: user.userImageUrl) else {fatalError("Unknown url")}
        userImageView.sd_setImage(with: url, completed: nil)
        userNameLabel.text = user.userName
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
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.left.equalTo(containerView.snp.left)
            make.right.equalTo(containerView.snp.right)
            make.height.equalTo(containerView.snp.width)
        }
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(containerView.snp.left).inset(10)
            make.right.equalTo(containerView.snp.right).inset(10)
            make.top.equalTo(userImageView.snp.bottom).inset(-10)
        }
    }
}

