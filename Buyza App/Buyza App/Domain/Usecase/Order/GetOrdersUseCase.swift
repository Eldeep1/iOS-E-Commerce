//
//  GetOrdersUseCase.swift
//  Buyza App
//

import Foundation

protocol GetOrdersUseCaseProtocol {
    func execute() async throws -> [Order]
}

struct GetOrdersUseCase: GetOrdersUseCaseProtocol {
    private let repository: OrderRepositoryProtocol

    init(repository: OrderRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Order] {
        try await repository.fetchOrders()
    }
}
