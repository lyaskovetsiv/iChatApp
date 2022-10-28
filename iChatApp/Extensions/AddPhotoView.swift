//
//  AddPhotoView.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import UIKit
import SnapKit

class AddPhotoView: UIView {
    
    lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "profile")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let plusImage = UIImage(named: "plus")
        button.setImage(plusImage, for: .normal)
        button.tintColor = .black
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoView)
        addSubview(addButton)
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoView.layer.cornerRadius = photoView.bounds.width / 2
    }
    
    private func setupConstraits(){
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.snp.makeConstraints { make in
            make.left.equalTo(photoView.snp.right).inset(-30)
            make.centerY.equalTo(photoView.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: photoView.bottomAnchor),
            self.rightAnchor.constraint(equalTo: addButton.rightAnchor)
        ])
    }
}
