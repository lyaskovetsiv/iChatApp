//
//  WaitingChatCell.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import UIKit
import SnapKit
import SDWebImage

class WaitingChatCell: UICollectionViewCell, ConfiguringCell {
    
    static let reuseIdentifier = "waitingChatCell"
    
    private var userImageView = UIImageView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupCell()
        addSubview(userImageView)
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        userImageView.image = nil
    }
    
    private func setupCell(){
        
        backgroundColor = .systemMint
        self.layer.cornerRadius = 5
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat = value as? MChat else {fatalError("Unknown kind of data")}
        userImageView.sd_setImage(with: URL(string: chat.friendUserImageURL), completed: nil)
    }
    
}


//MARK: --Constaraits
extension WaitingChatCell{
    
    private func setupConstraits(){
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.snp.makeConstraints({ make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        })
    }
    
}
