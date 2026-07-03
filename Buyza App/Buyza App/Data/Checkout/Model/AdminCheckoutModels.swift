//
//  AdminCheckoutModels.swift
//  Buyza App
//
//  Created by depo on 03/07/2026.
//


struct DraftOrderCreateResponse: Decodable {
    let draftOrderCreate: DraftOrderCreateData
}

struct DraftOrderCreateData: Decodable {
    let draftOrder: DraftOrderNode?
    let userErrors: [AdminUserError]
}

struct DraftOrderNode: Decodable {
    let id: String
}

struct DraftOrderCompleteResponse: Decodable {
    let draftOrderComplete: DraftOrderCompleteData
}

struct DraftOrderCompleteData: Decodable {
    let draftOrder: CompletedDraftOrderNode?
    let userErrors: [AdminUserError]
}

struct CompletedDraftOrderNode: Decodable {
    let order: AdminOrderNode?
}

struct AdminOrderNode: Decodable {
    let id: String
    let name: String
    let totalPriceSet: AdminPriceSet
    let displayFinancialStatus: String
    let createdAt: String
}

struct AdminPriceSet: Decodable {
    let shopMoney: AdminMoney
}

struct AdminMoney: Decodable {
    let amount: String
}

struct CustomerOrdersResponse: Decodable {
    let customer: CustomerOrdersData?
}

struct CustomerOrdersData: Decodable {
    let orders: CustomerOrdersList
}

struct CustomerOrdersList: Decodable {
    let nodes: [AdminOrderNode]
}

struct AdminUserError: Decodable {
    let message: String
}

struct CustomerGIDResponse: Decodable {
    let customer: CustomerGIDNode?
}

struct CustomerGIDNode: Decodable {
    let id: String
}

struct DraftOrderLineItemInput: Encodable {
    let variantId: String
    let quantity: Int
}

// MARK: - Cart Models
struct CartLinesQueryResponse: Decodable {
    let cart: CartLinesQueryCartNode?
}

struct CartLinesQueryCartNode: Decodable {
    let lines: CartLinesQueryConnection
}

struct CartLinesQueryConnection: Decodable {
    let edges: [CartLinesQueryEdge]
}

struct CartLinesQueryEdge: Decodable {
    let node: CartLinesQueryNode
}

struct CartLinesQueryNode: Decodable {
    let quantity: Int
    let merchandise: CartLinesQueryMerchandise
}

struct CartLinesQueryMerchandise: Decodable {
    let id: String
}
