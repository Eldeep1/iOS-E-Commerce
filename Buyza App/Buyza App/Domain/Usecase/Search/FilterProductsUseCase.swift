//
//  FilterProductsUseCase.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 03/07/2026.
//

import Foundation

protocol FilterProductsUseCaseProtocol {
    func fetchProducts(
        source: CollectionProductsSource,
        criteria: ProductFilterCriteria
    ) async throws -> [Product]

    func applyLocalFilters(
        products: [Product],
        criteria: ProductFilterCriteria
    ) -> [Product]
}

final class FilterProductsUseCase: FilterProductsUseCaseProtocol {
    private let repository: HomeRepoProtocol
    private let searchUseCase: SearchProductsUseCaseProtocol

    init(
        repository: HomeRepoProtocol,
        searchUseCase: SearchProductsUseCaseProtocol = SearchProductsUseCase(
            repository: HomeRepoImp(remoteDataSource: HomeRemoteDataSource())
        )
    ) {
        self.repository = repository
        self.searchUseCase = searchUseCase
    }

    func fetchProducts(
        source: CollectionProductsSource,
        criteria: ProductFilterCriteria
    ) async throws -> [Product] {
        let response = try await repository.fetchFilteredProducts(
            source: source,
            criteria: criteria,
            limit: 50
        )
        return response.products
    }

    func applyLocalFilters(
        products: [Product],
        criteria: ProductFilterCriteria
    ) -> [Product] {
        var result = searchUseCase.filter(
            products: products,
            query: ProductSearchQuery(text: criteria.searchText)
        )

        if let minPrice = criteria.minPrice {
            result = result.filter { $0.price >= minPrice }
        }

        if let maxPrice = criteria.maxPrice {
            result = result.filter { $0.price <= maxPrice }
        }

        switch criteria.sort {
        case .recommended:
            break
        case .priceLowToHigh:
            result = result.sorted { $0.price < $1.price }
        case .priceHighToLow:
            result = result.sorted { $0.price > $1.price }
        case .titleAZ:
            result = result.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }

        return result
    }
}
