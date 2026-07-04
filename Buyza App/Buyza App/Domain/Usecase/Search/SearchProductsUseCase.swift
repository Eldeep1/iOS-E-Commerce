//
//  SearchProductsUseCase.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 02/07/2026.
//

import Foundation

protocol SearchProductsUseCaseProtocol {
    func execute(query: ProductSearchQuery) async throws -> [Product]
    func filter(products: [Product], query: ProductSearchQuery) -> [Product]
}

final class SearchProductsUseCase: SearchProductsUseCaseProtocol {
    private let repository: HomeRepoProtocol
    
    init(repository: HomeRepoProtocol) {
        self.repository = repository
    }

    func execute(query: ProductSearchQuery) async throws -> [Product] {
        guard query.isValid else { return [] }

        let response = try await repository.fetchProducts(limit: 50)
        return filter(products: response.products, query: query)
    }

    func filter(products: [Product], query: ProductSearchQuery) -> [Product] {
        guard query.isValid else { return products }

        let keyword = query.trimmedText.lowercased()

        return products.filter {
            $0.title.lowercased().contains(keyword)
            || $0.vendor.lowercased().contains(keyword)
            || $0.product_type.lowercased().contains(keyword)
            || $0.body_html?.lowercased().contains(keyword) ?? false
        }
    }
}