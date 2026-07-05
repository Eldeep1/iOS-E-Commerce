//
//  ProfileResponse.swift
//  Buyza App
//

import Foundation

struct FetchProfileResponse: Decodable {
    let data: FetchProfileData?
}

struct FetchProfileData: Decodable {
    let customer: CustomerProfileDTO?
}

struct CustomerProfileDTO: Decodable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let phone: String?
}

struct UpdateProfileResponse: Decodable {
    let data: UpdateProfileData?
}

struct UpdateProfileData: Decodable {
    let customerUpdate: CustomerUpdatePayload?
}

struct CustomerUpdatePayload: Decodable {
    let customer: CustomerProfileDTO?
    let customerUserErrors: [ProfileUserError]?
}

struct ProfileUserError: Decodable {
    let field: [String]?
    let message: String
}
