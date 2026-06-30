//
//  AuthRepoImp.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import Foundation

struct AuthRepoImp : AuthRepoProtocol {
    let authService : AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func loginUser(email: String, password: String) async throws -> UserModel {
        do {
            let firebaseModel = try await authService.signIn(email: email, password: password)
            
            return UserModel(
                uid: firebaseModel.uid,
                email: firebaseModel.email ?? email,
                name: firebaseModel.name ?? "User"
            )
        } catch {
            throw AuthError.firebaseError(error.localizedDescription)
            
        }
    }
    
    func createUser(email: String, password: String, name: String) async throws -> UserModel {
        do {
            let firebaseModel = try await authService.createAccount(email: email, password: password, name: name)
            
            return UserModel(
                uid: firebaseModel.uid,
                email: firebaseModel.email ?? email,
                name: firebaseModel.name ?? name
            )
        } catch {
            throw AuthError.firebaseError(error.localizedDescription)
        }
    }
    
    
}
