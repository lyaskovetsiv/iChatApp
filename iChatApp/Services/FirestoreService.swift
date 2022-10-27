//
//  FirestoreService.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 27.10.2022.
//

import Foundation
import FirebaseAuth
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
                         username: username!,
                         email: email!,
                         sex: sex!,
                         description: description!,
                         avatarStringUrl: "not exist")
        
        db.collection("users").document(mUser.id).setData(["id": id,
                                                           "username": username!,
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
    
    func getUser(user: User, completionBlock: @escaping (Result<MUser, Error>)->Void){
        
        let document = db.collection("users").document(user.uid)
  
        document.getDocument { document, error in
            
            guard let document = document else {
                completionBlock(.failure(UserErrors.canNotGetUserData))
                return
            }
            
            guard let mUser = MUser(document: document) else {
                completionBlock(.failure(UserErrors.canNotUnwrapToMUser))
                return
            }
            completionBlock(.success(mUser))
        }
    }
}
