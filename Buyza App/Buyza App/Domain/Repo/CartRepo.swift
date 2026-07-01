//
//  CartRepo.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//

protocol CartRepositoryProtocol {

    func createCart(variantID: String, quantity: Int) async throws -> CartSummary

    func fetchCart(cartID: String) async throws -> CartSummary

    func addLines(cartID: String, variantID: String, quantity: Int) async throws -> CartSummary

    func updateLine(cartID: String, lineID: String, quantity: Int) async throws -> CartSummary

    func removeLine(cartID: String, lineID: String) async throws -> CartSummary
}
