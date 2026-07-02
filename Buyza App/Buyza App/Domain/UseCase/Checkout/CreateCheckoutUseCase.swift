//
//  CreateCheckoutUseCase.swift
//  Buyza App
//

import Foundation

struct CreateCheckoutUseCase {
    private let repository: CheckoutRepository
    
    init(repository: CheckoutRepository) {
        self.repository = repository
    }
    
    func execute(cartID: String, addressID: String?) async throws -> CheckoutSummary {
        return try await repository.createCheckout(cartID: cartID, addressID: addressID)
    }
}
