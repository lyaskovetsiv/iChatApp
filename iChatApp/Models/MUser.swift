//
//  MUser.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import Foundation
import UIKit
 
struct MUser: Hashable {
    
    var id = UUID()
    var userName: String
    var userImage: UIImage?
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    
    static func == (lhs: MUser, rhs: MUser)->Bool{
        return lhs.id == rhs.id
    }
    
    func contains(text: String?)->Bool{
        guard let text = text else {return true}
        if text.isEmpty {return true}
        let lowercasedText = text.lowercased()
        return userName.lowercased().contains(lowercasedText)
    }
    
}
