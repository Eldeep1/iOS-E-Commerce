//
//  CartDomain.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//

import Foundation


struct CartSummary {
    let cartID: String
    let items: [CartItem]
    let subtotal: Decimal
    let total: Decimal
    let currencyCode: String
}

struct CartItem: Identifiable {
    let id: String
    let variantID: String
    let productTitle: String
    let brandName: String
    let imageURL: URL?
    let unitPrice: Decimal
    let currencyCode: String
    var quantity: Int
}
