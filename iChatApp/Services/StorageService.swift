//
//  StorageService.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 28.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

class StorageService{
    
    static let shared = StorageService()

    private let storageRef = Storage.storage().reference()
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    private var avatarsRef: StorageReference{
        storageRef.child("avatars")
    }
    
    private init(){}
    
    func uploadPhoto(with photo: UIImage, completionBlock: @escaping (Result<URL, Error>)->Void){
       
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {return}
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completionBlock(.failure(error!))
                return
            }
            //Скачиваем ссылку на загруженную картинку
            self.avatarsRef.child(self.currentUserId).downloadURL { url, error in
                guard let downloadUrl = url else {
                    completionBlock(.failure(error!))
                    return
                }
                completionBlock(.success(downloadUrl))
            }
        }
    }
}
