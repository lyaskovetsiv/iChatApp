//
//  MChat.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import Foundation
import UIKit
import FirebaseFirestore

struct MChat: Hashable {
    
    var friendId: String
    var friendUserName: String
    var friendUserImageURL: String
    var friendLastMessage: String
    
    var representation: [String : Any]{
        var rep = [
            "id": self.friendId,
            "name": self.friendUserName,
            "imageURL": self.friendUserImageURL,
            "lastMessage": self.friendLastMessage
        ]
        return rep
    }
    
    init(friendId: String, friendUserName: String, friendUserImageURL: String, friendLastMessage: String){
        self.friendId = friendId
        self.friendUserName = friendUserName
        self.friendUserImageURL = friendUserImageURL
        self.friendLastMessage = friendLastMessage
    }
    
    init?(document: QueryDocumentSnapshot){
        let data = document.data()
        guard let userId = data["id"] as? String else {return nil}
        guard let userName = data["name"] as? String else {return nil}
        guard let imageURL = data["imageURL"] as? String else {return nil}
        guard let lastMessage = data["lastMessage"] as? String else {return nil}
        
        self.friendId = userId
        self.friendUserName = userName
        self.friendUserImageURL = imageURL
        self.friendLastMessage = lastMessage
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs: MChat)->Bool{
        return lhs.friendId == rhs.friendId
    }
}
