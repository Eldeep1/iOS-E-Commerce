//
//  FirebaseServices.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

protocol AuthServiceProtocol {
    func createAccount(email: String, password: String, name:String) async throws -> AuthDataResultModel
    func signIn(email: String, password: String) async throws -> AuthDataResultModel
    @MainActor func signInWithGoogle() async throws -> AuthDataResultModel
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
        
        // Send verification email
        try await authResult.user.sendEmailVerification()
        
        try await authResult.user.reload()
        
        return AuthDataResultModel(user: authResult.user)
    }
    
    func signIn(email:String, password:String)async throws-> AuthDataResultModel{
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        print(authResult.user.uid)
        
        print("Yaaaay")
        return AuthDataResultModel(user: authResult.user)
    }
    
    @MainActor
    func signInWithGoogle() async throws -> AuthDataResultModel {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.firebaseError("No client ID found.")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let topVC = UIApplication.shared.getRootViewController()
        
        let result: GIDSignInResult
        do {
            result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        } catch {
            let nsError = error as NSError
            if nsError.domain == kGIDSignInErrorDomain && nsError.code == -5 { // -5 is GIDSignInError.canceled
                throw AuthError.userCanceled
            }
            throw AuthError.firebaseError(error.localizedDescription)
        }
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.firebaseError("No ID token found.")
        }
        let accessToken = result.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
        let authResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authResult.user)
    }
}
