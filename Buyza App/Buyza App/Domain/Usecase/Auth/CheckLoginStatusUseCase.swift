//
//  CheckLoginStatusUseCase.swift
//  Buyza App
//
//  Created by depo on 29/06/2026.
//


struct CheckLoginStatusUseCase {
    private let authRepository: AuthRepoProtocol
    
    init(authRepository: AuthRepoProtocol) {
        self.authRepository = authRepository
    }
    
    func execute() -> Bool {
        return authRepository.isUserLoggedIn()
    }
}
