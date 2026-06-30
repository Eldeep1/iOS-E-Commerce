//
//  FetchCartUseCase.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//

protocol FetchCartUseCaseProtocol {
    func execute(cartID: String) async throws -> CartSummary
}

struct FetchCartUseCase: FetchCartUseCaseProtocol {
    private let repository: CartRepositoryProtocol

    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    func execute(cartID: String) async throws -> CartSummary {
        return try await repository.fetchCart(cartID: cartID)
    }
}
