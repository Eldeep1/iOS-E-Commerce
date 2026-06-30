//
//  ShopifyCustomerModels.swift
//  Buyza App
//
//  Created by depo on 29/06/2026.
//

import Foundation

// MARK: - Request Variables
struct CustomerVariables: Encodable {
    let input: CustomerCreateInputData
}

struct CustomerCreateInputData: Encodable {
    let email: String
    let password: String
}

// MARK: - Response Models
struct CustomerCreateResponse: Decodable {
    let customerCreate: CustomerCreatePayload
}

struct CustomerCreatePayload: Decodable {
    let customer: CustomerNode?
    let customerUserErrors: [ShopifyUserError]
}

struct CustomerNode: Decodable {
    let id: String
}

struct ShopifyUserError: Decodable {
    let field: [String]?
    let message: String
}
