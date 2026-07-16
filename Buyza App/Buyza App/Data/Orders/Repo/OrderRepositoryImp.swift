//
//  OrderRepositoryImp.swift
//  Buyza App
//

import Foundation

final class OrderRepositoryImp: OrderRepositoryProtocol {
    private let remoteDataSource: OrderDataSourceProtocol

    init(remoteDataSource: OrderDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchOrders() async throws -> [Order] {
        let dtos = try await remoteDataSource.fetchOrders()
        return dtos.map(map(dto:))
    }

    private func map(dto: OrderDTO) -> Order {
        let lineItems = (dto.lineItems?.edges ?? []).enumerated().map { index, edge in
            mapLineItem(dto: edge.node, orderId: dto.id, index: index)
        }

        return Order(
            id: dto.id,
            orderNumber: dto.orderNumber,
            name: dto.name,
            processedAt: parseDate(dto.processedAt),
            financialStatus: dto.financialStatus,
            fulfillmentStatus: dto.fulfillmentStatus,
            totalAmount: decimal(from: dto.totalPrice?.amount),
            currencyCode: dto.totalPrice?.currencyCode ?? "USD",
            lineItems: lineItems
        )
    }

    private func mapLineItem(dto: OrderLineItemDTO, orderId: String, index: Int) -> OrderLineItem {
        OrderLineItem(
            id: "\(orderId)-\(index)",
            title: dto.title,
            quantity: dto.quantity,
            imageURL: dto.variant?.image?.url.flatMap(URL.init(string:)),
            totalAmount: dto.originalTotalPrice.map { decimal(from: $0.amount) },
            currencyCode: dto.originalTotalPrice?.currencyCode
        )
    }

    private func decimal(from amount: String?) -> Decimal {
        Decimal(string: amount ?? "0") ?? 0
    }

    private func parseDate(_ value: String?) -> Date? {
        guard let value else { return nil }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: value) {
            return date
        }

        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: value)
    }
}
