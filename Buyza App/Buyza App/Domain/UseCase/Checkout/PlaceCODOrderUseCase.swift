//
//  PlaceCODOrderUseCase.swift
//  Buyza App
//

import Foundation

struct PlaceCODOrderUseCase {
    private let repository: CheckoutRepository

    init(repository: CheckoutRepository) {
        self.repository = repository
    }

    func execute(cartID: String, address: Address, customerID: String, discountAmount: Double, discountCode: String?) async throws -> Order {
        return try await repository.placeCODOrder(cartID: cartID, address: address, customerID: customerID, discountAmount: discountAmount, discountCode: discountCode)
    }
}
