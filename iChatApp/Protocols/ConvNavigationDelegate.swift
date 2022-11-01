//
//  ConvNavigationDelegate.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 31.10.2022.
//

import Foundation

protocol ConvNavigationDelegate: AnyObject{
    func removeWaitingChat(chat: MChat)
    func changeToActive(chat: MChat)
}
