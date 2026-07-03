//
//  Order.swift
//  Buyza App
//

import Foundation

struct Order {
    let id: String
    let name: String
    let totalPrice: Double
    let paymentStatus: String  // "pending" | "paid" | "voided"
    let createdAt: String
}
