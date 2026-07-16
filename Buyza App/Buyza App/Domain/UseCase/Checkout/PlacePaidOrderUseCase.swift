//
//  PlacePaidOrderUseCase.swift
//  Buyza App
//
//  Created by depo on 06/07/2026.
//

import Foundation

struct PlacePaidOrderUseCase {
    private let repository: CheckoutRepository

    init(repository: CheckoutRepository) {
        self.repository = repository
    }

    func execute(cartID: String, address: Address, customerID: String, discountAmount: Double, discountCode: String?) async throws -> CheckoutOrder {
        return try await repository.placePaidOrder(cartID: cartID, address: address, customerID: customerID, discountAmount: discountAmount, discountCode: discountCode)
    }
}
