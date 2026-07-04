//
//  Order.swift
//  Buyza App
//

import Foundation

struct Order: Identifiable, Equatable {
    let id: String
    let orderNumber: Int
    let name: String
    let processedAt: Date?
    let financialStatus: String?
    let fulfillmentStatus: String?
    let totalAmount: Decimal
    let currencyCode: String
    let lineItems: [OrderLineItem]

    var itemCount: Int {
        lineItems.reduce(0) { $0 + $1.quantity }
    }

    var statusDisplay: String {
        if let fulfillmentStatus, !fulfillmentStatus.isEmpty {
            return fulfillmentStatus.replacingOccurrences(of: "_", with: " ").capitalized
        }
        if let financialStatus, !financialStatus.isEmpty {
            return financialStatus.replacingOccurrences(of: "_", with: " ").capitalized
        }
        return "Pending"
    }

    var formattedTotal: String {
        formatMoney(totalAmount, currencyCode: currencyCode)
    }

    var formattedDate: String {
        guard let processedAt else { return "—" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: processedAt)
    }

    var firstImageURL: URL? {
        lineItems.first?.imageURL
    }
}

struct OrderLineItem: Identifiable, Equatable {
    let id: String
    let title: String
    let quantity: Int
    let imageURL: URL?
    let totalAmount: Decimal?
    let currencyCode: String?
}

private func formatMoney(_ amount: Decimal, currencyCode: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode
    return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount) \(currencyCode)"
}
