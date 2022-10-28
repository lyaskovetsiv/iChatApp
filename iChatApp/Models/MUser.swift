//
//  MUser.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 19.10.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
 
struct MUser: Hashable {
    
    var id: String
    var userName: String
    var email: String
    var sex: String
    var description: String
    var userImageUrl: String
    
    init(id: String, username: String, email: String, sex: String, description: String, userImageUrl: String){
        self.id = id
        self.userName = username
        self.email = email
        self.sex = sex
        self.description = description
        self.userImageUrl = userImageUrl
    }
    
    init?(document: DocumentSnapshot){
        guard let data = document.data() else { return nil}
        guard let id = data["id"] as? String else {return nil}
        guard let username = data["username"] as? String else {return nil}
        guard let email = data["email"] as? String else {return nil}
        guard let sex = data["sex"] as? String else {return nil}
        guard let description = data["description"] as? String else {return nil}
        guard let userImageUrl = data["userImageUrl"] as? String else {return nil}
        
        self.id = id
        self.userName = username
        self.email = email
        self.sex = sex
        self.description = description
        self.userImageUrl = userImageUrl
    }
    
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
