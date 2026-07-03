//
//  CheckoutModel.swift
//  Buyza App
//
//  Created by depo on 02/07/2026.
//


struct CartQueryResponse: Decodable {
    let cart: ShopifyCartData?
}

struct CartBuyerIdentityResponse: Decodable {
    let cartBuyerIdentityUpdate: CartBuyerIdentityUpdateData
}

struct CartBuyerIdentityUpdateData: Decodable {
    let cart: ShopifyCartIdData?
    let userErrors: [CheckoutShopifyUserError]
}

struct ShopifyCartIdData: Decodable {
    let id: String
}

struct CartDiscountResponse: Decodable {
    let cartDiscountCodesUpdate: CartDiscountCodesUpdateData
}

struct CartDiscountCodesUpdateData: Decodable {
    let cart: ShopifyCartData?
    let userErrors: [CheckoutShopifyUserError]
}

struct ShopifyCartData: Decodable {
    let id: String
    let checkoutUrl: String
    let cost: ShopifyCartCost
}

struct ShopifyCartCost: Decodable {
    let subtotalAmount: ShopifyMoney
    let totalAmount: ShopifyMoney
}

struct ShopifyMoney: Decodable {
    let amount: String
}

struct CheckoutShopifyUserError: Decodable {
    let message: String
}
