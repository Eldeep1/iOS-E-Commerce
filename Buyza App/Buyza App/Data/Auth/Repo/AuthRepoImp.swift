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
            
            guard firebaseModel.isEmailVerified else {
                throw AuthError.emailNotVerified
            }
            let shopifyPassword = "\(firebaseModel.uid)_GAuth1!"
            var shopifyToken: String
            
            do {
//                shopifyToken = try await shopifyService.getCustomerToken(email: email, password: password)
                shopifyToken = try await shopifyService.getCustomerToken(email: email, password: shopifyPassword)

            } catch {
                let nameParts = firebaseModel.name?.split(separator: " ", maxSplits: 1)
                let firstName = nameParts?.first.map(String.init) ?? "Customer"
                let lastName = (nameParts?.count ?? 0) > 1 ? String(nameParts![1]) : "Buyza"
                
                shopifyToken = try await shopifyService.createCustomer(email: email, password: shopifyPassword, firstName: firstName, lastName: lastName)

            }
            
            try localDataSource.saveShopifyToken(shopifyToken)
            
            print("Login complete! Shopify Token saved.")
            return UserModel(
                uid: firebaseModel.uid,
                email: firebaseModel.email ?? email,
                name: firebaseModel.name ?? "User"
            )
        } catch let authError as AuthError {
            throw authError
        } catch {
            throw AuthError.firebaseError(error.localizedDescription)
        }
    }
    
    @MainActor
    func loginWithGoogle() async throws -> UserModel {
        do {
            let firebaseModel = try await firebaseService.signInWithGoogle()
            
            
            let shopifyPassword = "\(firebaseModel.uid)_GAuth1!"
            
            var shopifyToken: String
            
            do {
                // Try to log in to Shopify
                shopifyToken = try await shopifyService.getCustomerToken(email: firebaseModel.email ?? "", password: shopifyPassword)
            } catch {
                let nameParts = firebaseModel.name?.split(separator: " ", maxSplits: 1)
                let firstName = nameParts?.first.map(String.init) ?? "Customer"
                let lastName = (nameParts?.count ?? 0) > 1 ? String(nameParts![1]) : "Buyza"
                
                shopifyToken = try await shopifyService.createCustomer(email: firebaseModel.email ?? "", password: shopifyPassword, firstName: firstName, lastName: lastName)
            }
            
            try localDataSource.saveShopifyToken(shopifyToken)
            
            return UserModel(
                uid: firebaseModel.uid,
                email: firebaseModel.email ?? "",
                name: firebaseModel.name ?? "User"
            )
        } catch {
            throw AuthError.firebaseError(error.localizedDescription)
        }
    }
    
    func createUser(email: String, password: String, name: String) async throws -> UserModel {
        do {
            let firebaseModel = try await firebaseService.createAccount(email: email, password: password, name: name)
            
            // Do NOT create the Shopify account here. Wait until they verify email and login.
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
        
        // 2. Check if the Keychain has the Shopify Token
        let shopifyToken = try? localDataSource.getShopifyToken()
        let hasShopifyToken = shopifyToken != nil
        
        // Return true only if both exist!
        return hasFirebaseUser && hasShopifyToken
    }
    
    func sendPasswordReset(email: String) async throws {
        do {
            try await firebaseService.sendPasswordReset(email: email)
        } catch {
            throw AuthError.firebaseError(error.localizedDescription)
        }
    }
    
    func logout() async throws {
        do {
            try firebaseService.signOut()
            try localDataSource.clearShopifyToken()
            UserDefaults.standard.removeObject(forKey: "shopify_cart_id")
        } catch {
            throw AuthError.firebaseError(error.localizedDescription)
        }
    }
}
