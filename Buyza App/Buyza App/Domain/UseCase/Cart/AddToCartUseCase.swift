//
//  AddToCartUseCase.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//

protocol AddToCartUseCaseProtocol {
    func execute(cartID: String?, variantID: String, quantity: Int) async throws -> CartSummary
}

struct AddToCartUseCase: AddToCartUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    func execute(cartID: String?, variantID: String, quantity: Int) async throws -> CartSummary {
        guard quantity > 0 else { throw CartError.invalidQuantity }
        if let cartID, !cartID.isEmpty {
            // Cart already exists — add a new line to it
            return try await repository.addLines(cartID: cartID, variantID: variantID, quantity: quantity)
        } else {
            // No cart yet — create one with the first item
            return try await repository.createCart(variantID: variantID, quantity: quantity)
        }
    }
}
