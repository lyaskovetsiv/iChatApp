//
//  Validation.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 26.10.2022.
//

import Foundation

class Validation{
    
    static func isFilled(email: String?, password: String?, rePassword: String?)->Bool{
        guard let email = email,
                  email != nil,
                  let password = password,
                  password != nil,
                  let rePassword = rePassword,
                  rePassword != nil else {
            return false
        }
        return true
    }
    
    static func isFilled(email: String?, password: String?)->Bool{
        guard let email = email,
                  email != nil,
                  let password = password,
                  password != nil else {
            return false
        }
        return true
    }
    
    static func isValidEmail(email: String)->Bool{
        let emailRegEx = "^.+@.+\\{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    static func isSamePasswords(password: String, rePassword: String)->Bool{
        guard password == rePassword else {
            return false
        }
        return true
    }
    
    private static func check(text: String, regEx: String)->Bool{
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
