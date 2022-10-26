//
//  AuthErrors.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 26.10.2022.
//

import Foundation

enum AuthErrors: Error {
    case emptyFields
    case incorrectEmail
    case unmatchedPasswords
}

extension AuthErrors: LocalizedError{
    var errorDescription: String?{
        switch self{
        case .emptyFields:
            return NSLocalizedString("Some of you fields are empty", comment: "")
        case .incorrectEmail:
            return NSLocalizedString("Invalid format of email", comment: "")
        case .unmatchedPasswords:
            return NSLocalizedString("You passwords are not matched to each other", comment: "")
        }
    }
}
