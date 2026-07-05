//
//  GetUserProfileUseCase.swift
//  Buyza App
//

import Foundation

protocol GetUserProfileUseCaseProtocol {
    func execute() async throws -> UserProfile
}

struct GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    private let repository: ProfileRepoProtocol

    init(repository: ProfileRepoProtocol) {
        self.repository = repository
    }

    func execute() async throws -> UserProfile {
        try await repository.fetchProfile()
    }
}
