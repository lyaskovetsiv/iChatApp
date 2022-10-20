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
        backgroundColor = .systemMint
        self.layer.cornerRadius = 5
    
        addSubview(imageView)
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with value: MChat) {
        imageView.image = value.userImage
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
