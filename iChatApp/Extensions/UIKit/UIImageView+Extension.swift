//
//  UIImage+Extension.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 10.10.2022.
//

import Foundation
import UIKit

extension UIImageView{
    
    convenience init(with image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        self.image = image
        self.contentMode = contentMode
    }
    
    func setColor(color: UIColor){
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
