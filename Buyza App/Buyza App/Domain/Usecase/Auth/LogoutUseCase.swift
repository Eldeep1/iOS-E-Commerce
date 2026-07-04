//
//  LogoutUseCase.swift
//  Buyza App
//
//  Created by depo on 04/07/2026.
//

import Foundation

class LogoutUseCase {
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    func execute() async throws {
        try await repo.logout()
    }
}
