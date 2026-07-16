//
//  ApplyDiscountUseCase.swift
//  Buyza App
//

import Foundation

struct ApplyDiscountUseCase {
    private let repository: CheckoutRepository
    
    init(repository: CheckoutRepository) {
        self.repository = repository
    }
    
    func execute(checkoutID: String, discountCode: String) async throws -> CheckoutSummary {
        return try await repository.applyDiscount(checkoutID: checkoutID, discountCode: discountCode)
    }
}
