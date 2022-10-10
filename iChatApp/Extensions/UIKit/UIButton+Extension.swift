//
//  UIButton+Extension.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 10.10.2022.
//

import Foundation
import UIKit

extension UIButton{
    
    convenience init(title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont? = .avenit20(), cornerRadius: CGFloat = 4) {
        
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
    }
}
