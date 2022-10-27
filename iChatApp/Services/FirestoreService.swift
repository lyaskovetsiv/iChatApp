//
//  FirestoreService.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 27.10.2022.
//

import Foundation
import FirebaseFirestore

class FirestoreService{
    
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    
    private init(){}
    
    func saveProfile(with id: String, username: String?, email: String?, sex: String?, avatarStringURL: String? = "", description: String?, completionBlock: @escaping (Result<MUser, Error>)->Void){
        
        guard Validation.isFilled(username: username, email: email, sex: sex, description: description) else {
            completionBlock(.failure(UserErrors.notFilled))
            return
        }
        
       let mUser = MUser(id: id,
                         userName: username!,
                         email: email!,
                         sex: sex!,
                         description: description!,
                         userImage: "not exist")
        
        db.collection("users").document(mUser.id).setData(["username": username!,
                                                           "email": email!,
                                                           "sex": sex!,
                                                           "description": description!,
                                                           "avatarStringURL": "image"
                                                           ]) { error in
            if let error = error{
                completionBlock(.failure(error))
            }
            else{
                completionBlock(.success(mUser))
            }
        }
        
    }
}
