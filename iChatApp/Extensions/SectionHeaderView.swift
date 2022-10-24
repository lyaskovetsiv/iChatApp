//
//  SectionHeaderView.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 24.10.2022.
//

import Foundation
import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView{
    
    static let reuseIdentifier = "sectionHeader"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, font: UIFont, textColor: UIColor){
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = textColor
    }
    
    
}
