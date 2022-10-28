//
//  AuthService.swift
//  iChatApp
//
//  Created by Ivan Lyaskovets on 26.10.2022.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import SwiftUI


class AuthService{
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    private init(){}
    
    func createUser(email: String?, password: String?, confirmPassword: String?, completionBlock: @escaping (Result<User, Error>)->Void){
        
        //Все ли поля заполнены?
        guard Validation.isFilled(email: email, password: password, rePassword: confirmPassword) else {
            completionBlock(.failure(AuthErrors.emptyFields))
            return
        }
        
        //Правильный ли формат у почты?
        guard Validation.isValidEmail(email: email!) else {
            completionBlock(.failure(AuthErrors.incorrectEmail))
            return
        }
        
        //Совпадают ли пароли?
        guard Validation.isSamePasswords(password: password!, rePassword: confirmPassword!) else {
            completionBlock(.failure(AuthErrors.unmatchedPasswords))
            return
        }
        
        //Создаём юзера и возвращаем его в наше приложение (User)
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completionBlock(.failure(error!))
                return
            }
            completionBlock(.success(result.user))
        }
    }
    
    
    func loginIn(email: String?, password: String?, completionBlock: @escaping (Result<User, Error>)->Void){
        
        //Все ли поля заполнены?
        guard Validation.isFilled(email: email, password: password) else {
            completionBlock(.failure(AuthErrors.emptyFields))
            return
        }
        
        //Правильный ли формат у почты?
        guard Validation.isValidEmail(email: email!) else {
            completionBlock(.failure(AuthErrors.incorrectEmail))
            return
        }
        
        //Логинимся и возвращаем юзера в наше приложение (User)
        auth.signIn(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completionBlock(.failure(error!))
                return
            }
            completionBlock(.success(result.user))
        }
    }
    
}
