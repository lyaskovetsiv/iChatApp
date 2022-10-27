//
//  UserErrors.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 27.10.2022.
//

import Foundation

enum UserErrors: Error {
    case notFilled
    case photoNotExist
}

extension UserErrors: LocalizedError{
    var errorDescription: String?{
        switch self{
        case .notFilled:
            return NSLocalizedString("Some of your fields are not filled", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Image not found", comment: "")
        }
    }
}
