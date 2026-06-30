//
//  LoginUseCase.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import Foundation

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws -> UserModel
}

struct LoginUseCase: LoginUseCaseProtocol {
    
    private let authRepository: AuthRepoProtocol
    
    init(authRepository: AuthRepoProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String) async throws -> UserModel {
        guard email.contains("@") && email.count > 5 else {
            throw AuthError.invalidEmail
        }
        
        do {
            return try await authRepository.loginUser(email: email, password: password)
        } catch {
            throw AuthError.map(error)
        }
    }
}
