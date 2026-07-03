//
//  FetchLatestOrderUseCase.swift
//  Buyza App
//

import Foundation

struct FetchLatestOrderUseCase {
    private let repository: CheckoutRepository

    init(repository: CheckoutRepository) {
        self.repository = repository
    }

    func execute(customerID: String) async throws -> Order? {
        return try await repository.fetchLatestOrder(customerID: customerID)
    }
}
