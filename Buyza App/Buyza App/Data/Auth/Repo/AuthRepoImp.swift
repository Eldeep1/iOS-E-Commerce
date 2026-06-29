//
//  AuthRepoImp.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import Foundation
import FirebaseAuth
struct AuthRepoImp : AuthRepoProtocol {
    private let firebaseService : AuthServiceProtocol
    private let shopifyService: ShopifyAuthServiceProtocol
    private let localDataSource: LocalAuthDataSourceProtocol
    
    init(
        firebaseService: AuthServiceProtocol,
        shopifyService: ShopifyAuthServiceProtocol,
        localDataSource: LocalAuthDataSourceProtocol
    ) {
        self.firebaseService = firebaseService
        self.shopifyService = shopifyService
        self.localDataSource = localDataSource
    }
    
    
    func loginUser(email: String, password: String) async throws -> UserModel {
        do {
            let firebaseModel = try await firebaseService.signIn(email: email, password: password)
            
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
            print("we are here")
            let firebaseModel = try await firebaseService.createAccount(email: email, password: password, name: name)
            print(firebaseModel.uid)
            print("aaaaaa")
            print(firebaseModel.name)
            let shopifyID = try await shopifyService.createCustomer(email: email, password: password)
            print("that was saved successfully")
            try localDataSource.saveShopifyID(shopifyID)
            
            return UserModel(
                uid: firebaseModel.uid,
                email: firebaseModel.email ?? email,
                name: firebaseModel.name ?? name
            )
        } catch {
            throw AuthError.firebaseError(error.localizedDescription)
        }
    }
    
    func isUserLoggedIn() -> Bool {
            // 1. Check if Firebase remembers the user
            let hasFirebaseUser = Auth.auth().currentUser != nil
            
            // 2. Check if the Keychain has the Shopify ID
            let shopifyID = try? localDataSource.getShopifyID()
            let hasShopifyID = shopifyID != nil
            
            // Return true only if both exist!
            return hasFirebaseUser && hasShopifyID
        }

}
