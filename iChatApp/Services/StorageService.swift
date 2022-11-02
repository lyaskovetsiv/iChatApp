//
//  StorageService.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 28.10.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService{
    
    static let shared = StorageService()
    private let storageRef = Storage.storage().reference()
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    private var avatarsRef: StorageReference{
        return storageRef.child("avatars")
    }
    private var chatsRef: StorageReference{
        return storageRef.child("chats")
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
    
    func uploadImageMessage(with photo: UIImage, to chat: MChat, completionBlock: @escaping (Result<URL, Error>)->Void){
        
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {return}
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let chatName = [chat.friendId, currentUserId].joined()
        
        self.chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metadata){ metadata, error in
            //Подгрузилась ли дата?
            guard let _ = metadata else {
                completionBlock(.failure(error!))
                return
            }
            //Скачиваем ссылку на загруженную картинку
            self.chatsRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let downloadUrl = url else {
                    completionBlock(.failure(error!))
                    return
                }
                completionBlock(.success(downloadUrl))
            }
        }
    }
    
    func downloadImage(url: URL, completionBlock: @escaping (Result<UIImage?, Error>)->Void ){
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completionBlock(.failure(error!))
                return
            }
            
            completionBlock(.success(UIImage(data: imageData)))
            
            
        }
    }
    
}

