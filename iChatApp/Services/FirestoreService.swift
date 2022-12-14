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
    private var currentUser: MUser!
    
    private init(){}
    
    //MARK: --USER
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
            
            self.currentUser = mUser
            completionBlock(.success(mUser))
        }
    }
    
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
                    self.db.collection("users").document(mUser.id).setData(mUser.representation) { error in
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
    
    
    //MARK: --WAITING CHAT
    func createWaitingChat(message: String, reciever: MUser, completionBlock: @escaping(Result<Void,Error>)->Void ){
        
        let messagesRef = db.collection("users").document(reciever.id).collection("waitingChats").document(currentUser.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        
        let chat = MChat(friendId: currentUser.id,
                         friendUserName: currentUser.userName,
                         friendUserImageURL: currentUser.userImageUrl,
                         friendLastMessage: message.senderContent)

        
        db.collection("users").document(reciever.id).collection("waitingChats").document(currentUser.id).setData(chat.representation) { error in
           
            if let error = error{
                completionBlock(.failure(error))
                return
            }
            
            messagesRef.addDocument(data: message.representation) { error in
                if let error = error{
                    completionBlock(.failure(error))
                    return
                }
            }
            completionBlock(.success(Void()))
        }
    }
    
    private func getWaitingMessages(chat: MChat, completionBlock: @escaping(Result<[MMessage],Error>)->Void){
        let reference = db.collection("users").document(currentUser.id).collection("waitingChats").document(chat.friendId).collection("messages")
        
        reference.getDocuments { querySnapShot, error in
            
            if let error = error {
                completionBlock(.failure(error))
                return
            }
            
            guard let snapShot = querySnapShot else {return}
            
            var messages = [MMessage]()
            for document in snapShot.documents{
                guard let message = MMessage(document: document) else {return}
                messages.append(message)
            }
            
            completionBlock(.success(messages))
        }
    }
    
    private func deleteWaitingMessages(chat: MChat, completionBlock: @escaping(Result<Void,Error>)->Void){
        
        let messagesRef = db.collection("users").document(currentUser.id).collection("waitingChats").document(chat.friendId).collection("messages")
        
        getWaitingMessages(chat: chat) { result in
            switch result{
                case .success(let messages):
                    for message in messages{
                        guard let documentId = message.id else {return}
                        let messageRef = messagesRef.document(documentId).delete { error in
                            if let error = error{
                                completionBlock(.failure(error))
                                return
                            }
                            completionBlock(.success(Void()))
                        }
                    }
                case .failure(let error):
                    completionBlock(.failure(error))
            }
        }
    }
    
    func deleteWaitingChat(chat: MChat, completionBlock: @escaping(Result<Void,Error>)->Void){
        let ref = db.collection(["users",currentUser.id,"waitingChats"].joined(separator: "/"))
        ref.document(chat.friendId).delete { error in
            if let error = error{
                completionBlock(.failure(error))
                return
            }
            self.deleteWaitingMessages(chat: chat, completionBlock: completionBlock)
        }
    }
    
    
    //MARK: --ACTIVE CHAT
    private func createActiveChat(chat: MChat, messages: [MMessage], completionBlock: @escaping(Result<Void,Error>)->Void){
        
        let activeChatsRef = db.collection("users").document(currentUser.id).collection("activeChats")
        let activeChatMessRef = activeChatsRef.document(chat.friendId).collection("messages")
        
        activeChatsRef.document(chat.friendId).setData(chat.representation) { error in
            if let error = error {
                completionBlock(.failure(error))
                return
            }

            for message in messages {
                activeChatMessRef.addDocument(data: message.representation) { error in
                    if let error = error{
                        completionBlock(.failure(error))
                        return
                    }
                }
            }
            completionBlock(.success(Void()))
        }
    }
    
    func changeChatToActive(chat: MChat, completionBlock: @escaping (Result<Void, Error>)->Void){
        getWaitingMessages(chat: chat) { result in
            switch result{
                case .success(let messages):
                    self.deleteWaitingChat(chat: chat) { result in
                        switch result{
                            case .success():
                                self.createActiveChat(chat: chat, messages: messages) { result in
                                    switch result{
                                        case .success():
                                            completionBlock(.success(Void()))
                                        case .failure(let error):
                                            completionBlock(.failure(error))
                                    }
                                }
                            case .failure(let error):
                                completionBlock(.failure(error))
                        }
                    }
                case .failure(let error):
                    completionBlock(.failure(error))
            }
        }
    }
    
    //MARK: --SENDING
    func sendMessage(chat: MChat, message: MMessage, completionBlock: @escaping(Result<Void, Error>)->Void){
        
        let myMessagesRef = db.collection("users").document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        let friendRef = db.collection("users").document(chat.friendId).collection("activeChats").document(currentUser.id)
        let friendMessagesRef = friendRef.collection("messages")
        
        let chatForFriend = MChat(friendId: currentUser.id, friendUserName: currentUser.userName, friendUserImageURL: currentUser.userImageUrl, friendLastMessage: message.senderContent)
        
        //Создаём активный чат у друга
        friendRef.setData(chatForFriend.representation) { error in
            if let error = error{
                completionBlock(.failure(error))
                return
            }
            //Добавляем сообщение другу
            friendMessagesRef.addDocument(data: message.representation) { error in
                if let error = error{
                    completionBlock(.failure(error))
                    return
                }
                //Добавляем сообщение себе
                myMessagesRef.addDocument(data: message.representation) { error in
                    if let error = error{
                        completionBlock(.failure(error))
                        return
                    }
                    completionBlock(.success(Void()))
                }
            }
        }
    }
    
}
