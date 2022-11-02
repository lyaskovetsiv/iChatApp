//
//  MMessage.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 30.10.2022.
//

import UIKit
import MessageKit
import FirebaseFirestore

struct MMessage: Hashable, MessageType {
    
    var id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    } /// The unique identifier for the message.
    
    var kind: MessageKind {
        if let image = image{
            let mediaItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(mediaItem)
        }
        //
        else{
            return .text(senderContent)
        }
    } /// The kind of message and its underlying kind.
    
    var sender: SenderType /// The sender of the message.
    var sentDate: Date /// The date the message was sent.
    var senderContent: String
    var image: UIImage?
    var downloadURL: URL?
    
    var representation: [String : Any]{
        var rep: [String : Any] = [
                    "senderId": self.sender.senderId,
                    "senderName": self.sender.displayName,
                    "sendDate": self.sentDate ]
        //!!!!!!
        if let url = downloadURL?.absoluteString{
            rep["url"] = url
        }
        //
        else{
            rep["content"] = self.senderContent
        }
        
        return rep
    }
    
    init(user: MUser, content: String){
        self.id = nil
        self.sender = Sender(senderId: user.id, displayName: user.userName)
        self.senderContent = content
        self.sentDate = Date()
    }
    
    init?(user: MUser, image: UIImage){
        self.id = nil
        self.sender = Sender(senderId: user.id, displayName: user.userName)
        self.image = image
        self.senderContent = ""
        self.sentDate = Date()
    }
    
    init?(chat: MChat){
        self.id = nil
        self.sender = Sender(senderId: chat.friendId, displayName: chat.friendUserName)
        self.senderContent = chat.friendLastMessage
        self.sentDate = Date()
    }
    
    init?(document: QueryDocumentSnapshot){
        let data = document.data()
        guard let id = data["senderId"] as? String else {return nil}
        guard let username = data["senderName"] as? String else {return nil}
        guard let date = data["sendDate"] as? Timestamp else {return nil}
        
        self.id = document.documentID
        self.sender = Sender(senderId: id, displayName: username)
        self.sentDate = date.dateValue()
        
        if let content = data["content"] as? String{
            self.senderContent = content
            self.downloadURL = nil
        }
        else if let urlString = data["url"] as? String, let url = URL(string: urlString){
            self.downloadURL = url
            self.senderContent = ""
        }
        else{
            return nil
        }
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(messageId)
    }
}

extension MMessage: Comparable{
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
