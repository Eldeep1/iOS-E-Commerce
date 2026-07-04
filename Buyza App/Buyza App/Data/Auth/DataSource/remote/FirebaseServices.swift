//
//  FirebaseServices.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func createAccount(email: String, password: String, name:String) async throws -> AuthDataResultModel
    func signIn(email: String, password: String) async throws -> AuthDataResultModel
    func signOut() throws
}

struct FirebaseServices :AuthServiceProtocol{
    func signOut() throws {
        try Auth.auth().signOut()
    }
    func createAccount(email: String, password: String,name:String) async throws-> AuthDataResultModel {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let changeRequest = authResult.user.createProfileChangeRequest()
        
        changeRequest.displayName = name
        
        try await changeRequest.commitChanges()
        
        try await authResult.user.reload()
        
        return AuthDataResultModel(user: authResult.user)
    }
    
    func signIn(email:String, password:String)async throws-> AuthDataResultModel{
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        print(authResult.user.uid)
        
        print("Yaaaay")
        return AuthDataResultModel(user: authResult.user)
        
        
    }
}
