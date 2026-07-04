//
//  LoginRepo.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import Foundation

protocol AuthRepoProtocol {
    func loginUser(email:String, password:String) async throws-> UserModel
    func createUser(email:String, password:String, name:String) async throws-> UserModel
    func isUserLoggedIn() -> Bool
    func logout() async throws
}
