//
//  MUser.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import Foundation
import UIKit
 
struct MUser: Hashable {
    
    var id: String
    var userName: String
    var email: String
    var sex: String
    var description: String
    var userImage: String
    
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
