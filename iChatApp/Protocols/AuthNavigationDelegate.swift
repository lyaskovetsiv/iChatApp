//
//  AuthNavigationDelegate.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 26.10.2022.
//

import Foundation

protocol AuthNavigationDelegate: AnyObject{
    func toLoginVC()
    func toSignUpVC()
}
