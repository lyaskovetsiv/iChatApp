//
//  UISegmentedControll.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 14.10.2022.
//

import Foundation
import UIKit

extension UISegmentedControl{
    
    convenience init(first: String, second: String) {
        
        self.init()
        insertSegment(withTitle: first, at: 0, animated: true)
        insertSegment(withTitle: second, at: 1, animated: true)
        selectedSegmentIndex = 0
        
    }
}
