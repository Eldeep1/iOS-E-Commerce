//
//  UpdateUserProfileUseCase.swift
//  Buyza App
//

import Foundation

protocol UpdateUserProfileUseCaseProtocol {
    func execute(profile: UserProfile) async throws -> UserProfile
}

struct UpdateUserProfileUseCase: UpdateUserProfileUseCaseProtocol {
    private let repository: ProfileRepoProtocol

    init(repository: ProfileRepoProtocol) {
        self.repository = repository
    }

    func execute(profile: UserProfile) async throws -> UserProfile {
        try await repository.updateProfile(profile)
    }
}
