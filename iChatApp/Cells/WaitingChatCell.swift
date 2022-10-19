//
//  WaitingChatCell.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import UIKit
import SnapKit

class WaitingChatCell: UICollectionViewCell {
    
    static let reuseIdentifier = "waitingChatCell"
    
    private var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemMint
        
        if let imageView = imageView {
            
            addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.snp.makeConstraints({ make in
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with image: UIImage){
        
    }
    
}
