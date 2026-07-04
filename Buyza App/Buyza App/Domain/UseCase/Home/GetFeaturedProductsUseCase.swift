//
//  GetRecommendedProductsUseCase.swift
//  Buyza App
//

import Foundation

protocol GetFeaturedProductsUseCaseProtocol {
    func execute() async throws -> [Product]
}

struct GetFeaturedProductsUseCase: GetFeaturedProductsUseCaseProtocol {
    private let repository: HomeRepoProtocol
    
    init(repository: HomeRepoProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Product] {
        let response = try await repository.fetchProducts(limit: 8)
        return response.products
    }
}
