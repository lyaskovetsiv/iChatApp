//
//  ListenerService.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 29.10.2022.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService{
    
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var currentUserId: String{
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserve(users: [MUser], completionBLock: @escaping (Result<[MUser], Error>)->Void) -> ListenerRegistration{
        
        var users = users
        
        let usersListener = usersRef.addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                completionBLock(.failure(error!))
                return
            }
            
            querySnapshot.documentChanges.forEach { dif in
               
                guard let mUser = MUser(document: dif.document) else {return}
                switch dif.type{
            
                case .added:
                    guard !users.contains(mUser) else {return}
                    guard mUser.id != self.currentUserId else {return}
                    users.append(mUser)
                case .modified:
                    guard let index = users.firstIndex(of: mUser) else {return}
                    users[index] = mUser
                case .removed:
                    guard let index = users.firstIndex(of: mUser) else {return}
                    users.remove(at: index)
                }
            }
            completionBLock(.success(users))
        }
        return usersListener
    }
    
    func chatsObserve(chats: [MChat], kindofChat: String, completionBlock: @escaping (Result<[MChat],Error>)->Void)->ListenerRegistration{
        
        var chats = chats
        
        let chatsListener = usersRef.document(currentUserId).collection(kindofChat).addSnapshotListener { querySnapShot, error in
            guard let querySnapShot = querySnapShot else {
                completionBlock(.failure(error!))
                return
            }
            
            querySnapShot.documentChanges.forEach { dif in
                
                guard let mChat = MChat(document: dif.document) else {return}
                
                switch dif.type{
                    case .added:
                        guard !chats.contains(mChat) else {return}
                        guard mChat.friendId != self.currentUserId else {return}
                        chats.append(mChat)
                    case .modified:
                        guard let index = chats.firstIndex(of: mChat) else {return}
                        chats[index] = mChat
                    case .removed:
                        guard let index = chats.firstIndex(of: mChat) else {return}
                        chats.remove(at: index)
                }
            }
            completionBlock(.success(chats))
        }
        
        return chatsListener
    }
    
    func messagesObserve(chat: MChat, completionBlock: @escaping(Result<MMessage, Error>)->Void)->ListenerRegistration{
        
        let ref = usersRef.document(currentUserId).collection("activeChats").document(chat.friendId).collection("messages")
        
        let listener = ref.addSnapshotListener { querySnapShot, error in
            guard let querySnapShot = querySnapShot else {
                completionBlock(.failure(error!))
                return
            }
            
            querySnapShot.documentChanges.forEach { dif in
                guard let message = MMessage(document: dif.document) else {return}
                    switch dif.type{
                        case .added:
                            completionBlock(.success(message))
                        case .modified:
                            break
                        case .removed:
                            break
                    }
            }
            
        }
        return listener
    }
    
}
