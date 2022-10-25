//
//  WaitingChatCell.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import UIKit
import SnapKit

class WaitingChatCell: UICollectionViewCell, ConfiguringCell {
    
    static let reuseIdentifier = "waitingChatCell"
    
    private var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        addSubview(imageView)
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell(){
        backgroundColor = .systemMint
        self.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat = value as? MChat else {fatalError("Unknown kind of data")}
        imageView.image = chat.userImage
    }
    
}


//MARK: --Constaraits
extension WaitingChatCell{
    
    private func setupConstraits(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints({ make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        })
    }
    
}
