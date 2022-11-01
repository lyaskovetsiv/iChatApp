//
//  MMessage.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 30.10.2022.
//

import Foundation
import UIKit
import FirebaseFirestore

struct MMessage: Hashable{
    
    let id: String?
    let senderId: String
    let senderUserName: String
    let senderContent: String
    let sendDate: Date
    
    var representation: [String : Any]{
        var rep: [String : Any] = [
                    "senderId": self.senderId,
                    "senderName": self.senderUserName,
                    "content": self.senderContent,
                    "sendDate": self.sendDate
                  ]
        return rep
    }
    
    init(user: MUser, content: String){
        self.id = nil
        self.senderId = user.id
        self.senderUserName = user.userName
        self.senderContent = content
        self.sendDate = Date()
    }
    
    init?(chat: MChat){
        self.id = nil
        self.senderId = chat.friendId
        self.senderContent = chat.friendLastMessage
        self.senderUserName = chat.friendUserName
        self.sendDate = Date()
    }
    
    init?(document: QueryDocumentSnapshot){
        let data = document.data()
        guard let id = data["senderId"] as? String else {return nil}
        guard let username = data["senderName"] as? String else {return nil}
        guard let content = data["content"] as? String else {return nil}
        guard let date = data["sendDate"] as? Timestamp else {return nil}
        
        self.id = document.documentID
        self.senderId = id
        self.senderUserName = username
        self.senderContent = content
        self.sendDate = date.dateValue()
    }
}
