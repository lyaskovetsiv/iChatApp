//
//  MChat.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import Foundation
import UIKit

struct MChat: Hashable {
    
    var id = UUID()
    var userName: String
    var userImage: UIImage?
    var lastMessage: String
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    
    static func == (lhs: MChat, rhs: MChat)->Bool{
        return lhs.id == rhs.id
    }
    
}
