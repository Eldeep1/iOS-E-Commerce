//
//  ProfileRepoImp.swift
//  Buyza App
//

import Foundation

struct ProfileRepoImp: ProfileRepoProtocol {
    private let remoteDataSource: ProfileDataSourceProtocol
    private let authService: AuthServiceProtocol

    init(
        remoteDataSource: ProfileDataSourceProtocol,
        authService: AuthServiceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.authService = authService
    }

    func fetchProfile() async throws -> UserProfile {
        try await remoteDataSource.fetchProfile()
    }

    func updateProfile(_ profile: UserProfile) async throws -> UserProfile {
        let updatedProfile = try await remoteDataSource.updateProfile(profile)

        if !updatedProfile.fullName.isEmpty {
            try await authService.updateDisplayName(updatedProfile.fullName)
        }

        return updatedProfile
    }
}
