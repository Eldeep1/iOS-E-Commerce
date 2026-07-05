//
//  UserProfile.swift
//  Buyza App
//

import Foundation

struct UserProfile: Equatable {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String

    var fullName: String {
        [firstName, lastName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
