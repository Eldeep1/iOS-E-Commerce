//
//  RemoveFromCartUseCase.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//

protocol RemoveFromCartUseCaseProtocol {
    func execute(cartID: String, lineID: String) async throws -> CartSummary
}

struct RemoveFromCartUseCase: RemoveFromCartUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    func execute(cartID: String, lineID: String) async throws -> CartSummary {
        return try await repository.removeLine(cartID: cartID, lineID: lineID)
    }
}
