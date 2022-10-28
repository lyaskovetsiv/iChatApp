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
    
    func saveProfile(with id: String, username: String?, email: String?, sex: String?, userImage: UIImage?, description: String?, completionBlock: @escaping (Result<MUser, Error>)->Void){
        
        //Заполнены ли поля?
        guard Validation.isFilled(username: username, email: email, sex: sex, description: description) else {
            completionBlock(.failure(UserErrors.notFilled))
            return
        }
        
        //Загружена ли картинка?
        guard Validation.isImageExists(image: userImage) else {
            completionBlock(.failure(UserErrors.photoNotExist))
            return
        }
        
       //Создаём юзера
       var mUser = MUser(id: id,
                         username: username!,
                         email: email!,
                         sex: sex!,
                         description: description!,
                         userImageUrl: "")
        
        //Пробуем загрузить нашу картинку в storage
        StorageService.shared.uploadPhoto(with: userImage!) { result in
            switch result{
                case .success(let url):
                    mUser.userImageUrl = url.absoluteString
                    self.db.collection("users").document(mUser.id).setData(["id": id,
                                                                   "username": username!,
                                                                   "email": email!,
                                                                   "sex": sex!,
                                                                   "description": description!,
                                                                   "userImageUrl": mUser.userImageUrl
                                                                   ]) { error in
                    if let error = error{
                        completionBlock(.failure(error))
                    }
                    else{
                        completionBlock(.success(mUser))
                    }
                }
                case .failure(let error):
                    completionBlock(.failure(error))
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
