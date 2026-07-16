//
//  RegisterUseCase.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import Foundation


protocol RegisterUseCaseProtocol {
    func execute(email: String, password: String, firstName: String, lastName: String) async throws -> UserModel
}

struct RegisterUseCase: RegisterUseCaseProtocol {
    
    private let authRepository: AuthRepoProtocol
    
    init(authRepository: AuthRepoProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String, firstName: String, lastName: String) async throws -> UserModel {
        guard email.contains("@") && email.count > 5 else {
            throw AuthError.invalidEmail
        }
        
        do {
            return try await authRepository.createUser(email: email, password: password, firstName: firstName, lastName: lastName)
        } catch {
            throw AuthError.map(error)
        }
    }
}
