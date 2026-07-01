//
//  CartResponse.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//

import Foundation

// MARK: - Core Response Models

struct Cart: Decodable {
    let id: String
    let lines: CartLinesConnection
    let cost: CartCost
}

struct CartLinesConnection: Decodable {
    let edges: [CartLineEdge]
}

struct CartLineEdge: Decodable {
    let node: CartLine
}

struct CartLine: Identifiable, Decodable {
    let id: String
    let quantity: Int
    let merchandise: CartMerchandise
    let cost: CartLineCost
}

struct CartMerchandise: Decodable {
    let id: String
    let title: String
    let product: CartProduct
}

struct CartProduct: Decodable {
    let title: String
    let vendor: String
    let featuredImage: CartImage?
}

struct CartImage: Decodable {
    let url: String
}

struct CartCost: Decodable {
    let totalAmount: MoneyV2
    let subtotalAmount: MoneyV2
}

struct CartLineCost: Decodable {
    let totalAmount: MoneyV2
}

struct MoneyV2: Decodable {
    let amount: String
    let currencyCode: String
}



struct CartUserError: Decodable {
    let field: [String]?
    let message: String
}

struct CartCreateData: Decodable {
    let cartCreate: CartCreatePayload
}

struct CartCreatePayload: Decodable {
    let cart: Cart?
    let userErrors: [CartUserError]?
}

struct CartQueryData: Decodable {
    let cart: Cart?
}

struct CartLinesAddData: Decodable {
    let cartLinesAdd: CartPayload
}

struct CartLinesUpdateData: Decodable {
    let cartLinesUpdate: CartPayload
}

struct CartLinesRemoveData: Decodable {
    let cartLinesRemove: CartPayload
}

struct CartPayload: Decodable {
    let cart: Cart?
    let userErrors: [CartUserError]?
}
