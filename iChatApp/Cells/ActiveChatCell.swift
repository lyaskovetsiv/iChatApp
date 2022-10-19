//
//  ActiveChatCell.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import UIKit

class ActiveChatCell: UICollectionViewCell {
    
    static let reuseIdentifier = "activeChatCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(){
        
    }
    
}
