//
//  UIButton+Extension.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 10.10.2022.
//

import Foundation
import UIKit
import SnapKit

extension UIButton{
    
    convenience init(title: String,
                     titleColor: UIColor,
                     backgroundColor: UIColor,
                     font: UIFont? = .avenit20(),
                     cornerRadius: CGFloat = 4,
                     shadows: Bool = false) {
        
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if shadows{
            self.layer.shadowColor = UIColor.systemGray.cgColor //Color
            self.layer.shadowRadius = 7 
            self.layer.shadowOpacity = 0.8 //
            self.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        }
        
    }
    
    func customizeGoogleImage(){
        let image = UIImageView(with: UIImage(named: "google"), contentMode: .scaleAspectFit)
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).inset(40)
        }
    }
}
