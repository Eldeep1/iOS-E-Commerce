//
//  AuthDataResultModel.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid : String
    let email: String?
    let name: String?
    let isEmailVerified: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.name = user.displayName
        self.isEmailVerified = user.isEmailVerified
    }
}
