//
//  Validation.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 26.10.2022.
//

import Foundation
import UIKit

class Validation{
    
    static func isFilled(email: String?, password: String?, rePassword: String?)->Bool{
        guard let email = email,
                  email != "",
                  let password = password,
                  password != "",
                  let rePassword = rePassword,
                  rePassword != "" else {
            return false
        }
        return true
    }
    
    static func isImageExists(image: UIImage?)->Bool{
        guard let image = image,
              image != UIImage(named: "defaultUser") else {return false}
        return true
    }
    
    static func isFilled(email: String?, password: String?)->Bool{
        guard let email = email,
                  email != "",
                  let password = password,
                  password != "" else {
            return false
        }
        return true
    }
    
    static func isValidEmail(email: String)->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return check(text: email, regEx: emailRegEx)
    }
    
    static func isFilled(username: String?, email: String?,  sex: String?, description: String?)->Bool{
        guard let username = username,
                  username != "",
                  let email = email,
                  email != "",
                  let sex = sex,
                  sex != "",
                  let description = description,
                  description != "" else {
            return false
        }
        return true
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
