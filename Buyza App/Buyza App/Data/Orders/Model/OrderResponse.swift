//
//  OrderResponse.swift
//  Buyza App
//

import Foundation

struct FetchOrdersResponse: Decodable {
    let data: FetchOrdersData?
}

struct FetchOrdersData: Decodable {
    let customer: CustomerOrdersData?
}

struct CustomerOrdersData: Decodable {
    let orders: OrderConnection?
}

struct OrderConnection: Decodable {
    let edges: [OrderEdge]
}

struct OrderEdge: Decodable {
    let node: OrderDTO
}

struct OrderDTO: Decodable {
    let id: String
    let orderNumber: Int
    let name: String
    let processedAt: String?
    let financialStatus: String?
    let fulfillmentStatus: String?
    let totalPrice: MoneyDTO?
    let lineItems: OrderLineItemConnection?
}

struct OrderLineItemConnection: Decodable {
    let edges: [OrderLineItemEdge]
}

struct OrderLineItemEdge: Decodable {
    let node: OrderLineItemDTO
}

struct OrderLineItemDTO: Decodable {
    let title: String
    let quantity: Int
    let originalTotalPrice: MoneyDTO?
    let variant: OrderVariantDTO?
}

struct OrderVariantDTO: Decodable {
    let image: OrderImageDTO?
}

struct OrderImageDTO: Decodable {
    let url: String?
}

struct MoneyDTO: Decodable {
    let amount: String
    let currencyCode: String
}
