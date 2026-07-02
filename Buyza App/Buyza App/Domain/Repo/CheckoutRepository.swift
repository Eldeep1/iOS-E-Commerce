//
//  CheckoutRepository.swift
//  Buyza App
//

import Foundation

protocol CheckoutRepository {
    func createCheckout(cartID: String, addressID: String?) async throws -> CheckoutSummary
    func applyDiscount(checkoutID: String, discountCode: String) async throws -> CheckoutSummary
}
