//
//  UITextField+Extensions.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 12.10.2022.
//

import Foundation
import UIKit

extension UITextField{
    
    convenience init(font: UIFont? = .avenit20(),
                     placeholderText: String) {
        self.init()
        self.font = font
        self.placeholder = placeholderText
        self.borderStyle = .none
    }
}
