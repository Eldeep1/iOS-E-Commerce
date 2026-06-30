//
//  CartError.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//


import Foundation

enum CartError: Error, LocalizedError {
    case invalidQuantity
    case cartNotFound
    case networkError(String)
    var errorDescription: String? {
        switch self {
        case .invalidQuantity: return "Quantity must be greater than zero."
        case .cartNotFound: return "Your cart could not be found."
        case .networkError(let msg): return msg
        }
    }
}
