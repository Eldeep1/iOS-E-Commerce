//
//  OrderError.swift
//  Buyza App
//

import Foundation

enum OrderError: LocalizedError {
    case notAuthenticated
    case networkError(String)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Please sign in to view your orders."
        case .networkError(let message):
            return message
        case .decodingFailed:
            return "Unable to load orders. Please try again."
        }
    }
}
