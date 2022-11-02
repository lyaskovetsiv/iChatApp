//
//  ChatVC.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 01.11.2022.
//

import UIKit
import MessageKit
import SDWebImage
import FirebaseFirestore
import InputBarAccessoryView


class ChatVC: MessagesViewController {

    private let currentUser: MUser!
    private let chat: MChat!
    private var messagesListener: ListenerRegistration?
    private var messages: [MMessage] = [MMessage]()
    
    init(currentUser: MUser, chat: MChat){
        self.currentUser = currentUser
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        title = chat.friendUserName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        messagesListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCameraBtn()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.backgroundColor = .systemBackground
        
        messagesListener = ListenerService.shared.messagesObserve(chat: chat, completionBlock: { result in
            switch result{
                case .success(var message):
                    if let url = message.downloadURL{
                        StorageService.shared.downloadImage(url: url) { [weak self] result in
                            guard let self = self else {return}
                            switch result{
                            case .success(let image):
                                message.image = image
                                self.insetNewMessage(message: message)
                            case .failure(let error):
                                self.showAlert(title: "Error", message: error.localizedDescription)
                            }
                        }
                    }else{
                        self.insetNewMessage(message: message)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    private func insetNewMessage(message: MMessage){
        guard !messages.contains(message) else {return}
        messages.append(message)
        messages.sort()
        messagesCollectionView.reloadData()
    }
    
    private func configureCameraBtn(){
        
        let cameraBtn = InputBarButtonItem(type: .system)
        cameraBtn.tintColor = .black
        let cameraImage = UIImage(named: "camera")
        cameraBtn.image = cameraImage
        
        cameraBtn.addTarget(self, action: #selector(cameraBtnPressed), for: .touchUpInside)
        cameraBtn.setSize(CGSize(width: 60, height: 30), animated: true)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false, animations: nil)
        messageInputBar.setStackViewItems([cameraBtn], forStack: .left, animated: true)
    }
    
    @objc private func cameraBtnPressed(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        }
        else{
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func sendPhoto(image: UIImage){
        
        StorageService.shared.uploadImageMessage(with: image, to: chat) { result in
            switch result{
                case .success(let url):
                    
                    guard var imageMessage = MMessage(user: self.currentUser, image: image) else {
                        self.showAlert(title: "Error", message: "Can't create message with image!")
                        return
                    }
                    //URL!
                    imageMessage.downloadURL = url
                
                    FirestoreService.shared.sendMessage(chat: self.chat, message: imageMessage) { result in
                        switch result{
                        case .success():
                            self.messagesCollectionView.scrollToLastItem()
                        case .failure(let error):
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
}

extension ChatVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        sendPhoto(image: image)
    }
}


//------------------MESSAGE KIT----------------------

//MARK: --MessageInputBarDelegate
extension ChatVC: InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let message = MMessage(user: currentUser, content: text)
        FirestoreService.shared.sendMessage(chat: chat, message: message) { result in
            switch result{
                case .success():
                    self.messagesCollectionView.scrollToLastItem()
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
}


//MARK: --MessagesDataSource
extension ChatVC: MessagesDataSource{
    
    func currentSender() -> SenderType {
        return Sender(senderId: currentUser.id, displayName: currentUser.userName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
}


//MARK: --MessagesLayoutDelegate
extension ChatVC: MessagesLayoutDelegate{
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.item % 4 == 0 {
            return 30
        }
        else{
            return 0
        }
    }
}


//MARK: --MessagesDisplayDelegate
extension ChatVC: MessagesDisplayDelegate{
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message){
            return .white
        }
        else{
            return .systemGray
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message){
            return .black
        }
        else{
            return .white
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if isFromCurrentSender(message: message){
            avatarView.sd_setImage(with: URL(string: currentUser.userImageUrl), completed: nil)
        }
        else{
            avatarView.sd_setImage(with: URL(string: chat.friendUserImageURL), completed: nil)
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
}
