//
//  UpdateQuantityUseCase.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//

protocol UpdateQuantityUseCaseProtocol {
    func execute(cartID: String, lineID: String, quantity: Int) async throws -> CartSummary
}

struct UpdateQuantityUseCase: UpdateQuantityUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    func execute(cartID: String, lineID: String, quantity: Int) async throws -> CartSummary {
        guard quantity >= 0 else { throw CartError.invalidQuantity }
        if quantity == 0 {
            return try await repository.removeLine(cartID: cartID, lineID: lineID)
        }
        return try await repository.updateLine(cartID: cartID, lineID: lineID, quantity: quantity)
    }
}
