//
//  CheckoutRepository.swift
//  Buyza App
//

import Foundation

protocol CheckoutRepository {
    func createCheckout(cartID: String, addressID: String?) async throws -> CheckoutSummary
    func applyDiscount(checkoutID: String, discountCode: String) async throws -> CheckoutSummary
    func placeCODOrder(cartID: String, address: Address, customerID: String, discountAmount: Double, discountCode: String?) async throws -> CheckoutOrder
    func fetchLatestOrder(customerID: String) async throws -> CheckoutOrder?
}
