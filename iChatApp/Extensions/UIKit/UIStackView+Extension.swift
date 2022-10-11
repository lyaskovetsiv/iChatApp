//
//  UIStackView+Extension.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 11.10.2022.
//

import Foundation
import UIKit

extension UIStackView{
    
    convenience init(arrangedView: [UIView], spacing: CGFloat, axis: NSLayoutConstraint.Axis) {
        self.init()
        
        for view in arrangedView{
            self.addArrangedSubview(view)
        }
        self.spacing = spacing
        self.axis = axis
        
    }
}
