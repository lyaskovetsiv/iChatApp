//
//  AuthService.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 26.10.2022.
//

import Foundation
import FirebaseAuth
import SwiftUI


class AuthService{
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    private init(){}
    
    func createUser(email: String?, password: String?, confirmPassword: String?, completionBlock: @escaping (Result<User, Error>)->Void){
        
        guard Validation.isFilled(email: email, password: password, rePassword: confirmPassword) else {
            completionBlock(.failure(AuthErrors.emptyFields))
            return
        }
        
        guard Validation.isValidEmail(email: email!) else {
            completionBlock(.failure(AuthErrors.incorrectEmail))
            return
        }
        
        guard Validation.isSamePasswords(password: password!, rePassword: confirmPassword!) else {
            completionBlock(.failure(AuthErrors.unmatchedPasswords))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completionBlock(.failure(error!))
                return
            }
            completionBlock(.success(result.user))
        }
    }
    
    func loginIn(email: String?, password: String?, completionBlock: @escaping (Result<User, Error>)->Void){
        
        guard Validation.isFilled(email: email, password: password) else {
            completionBlock(.failure(AuthErrors.emptyFields))
            return
        }
        
        guard Validation.isValidEmail(email: email!) else {
            completionBlock(.failure(AuthErrors.incorrectEmail))
            return
        }
        
        auth.signIn(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completionBlock(.failure(error!))
                return
            }
            completionBlock(.success(result.user))
        }
    }
    
    func test(){
        
    }
    
}
