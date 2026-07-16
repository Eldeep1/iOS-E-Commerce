//
//  ProfileRepo.swift
//  Buyza App
//

import Foundation

protocol ProfileRepoProtocol {
    func fetchProfile() async throws -> UserProfile
    func updateProfile(_ profile: UserProfile) async throws -> UserProfile
}
