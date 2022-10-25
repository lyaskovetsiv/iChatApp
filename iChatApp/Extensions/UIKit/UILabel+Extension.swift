//
//  UILabel+Extension.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 10.10.2022.
//

import Foundation
import UIKit

extension UILabel{
    
    convenience init(text: String,
                     font: UIFont? = .avenit20(),
                     textColor: UIColor? = .black){
        
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
