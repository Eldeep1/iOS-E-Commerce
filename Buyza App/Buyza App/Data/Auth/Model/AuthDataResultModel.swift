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
    init(user:User){
        self.uid=user.uid
        self.email=user.email
        self.name=user.displayName 
    }
}
