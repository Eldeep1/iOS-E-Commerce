//
//  HomeRemoteDataSource.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 01/07/2026.
//

import Foundation

protocol HomeRemoteDataSourceProtocol {
    func fetchProducts(limit: Int) async throws -> ProductsResponse
    func fetchFilteredProducts(
        source: CollectionProductsSource,
        criteria: ProductFilterCriteria,
        limit: Int
    ) async throws -> ProductsResponse
    func fetchCategories() async throws -> CategoryResponse
    func fetchBrands() async throws -> BrandResponse
}

final class HomeRemoteDataSource: HomeRemoteDataSourceProtocol {
    
    private let apiManager: ApiManager
    
    init(apiManager: ApiManager = .shared) {
        self.apiManager = apiManager
    }
    
    func fetchProducts(limit: Int) async throws -> ProductsResponse {
        let endpoint = ApiEndpoint.products(limit: limit)
        return try await apiManager.sendRequest(from: endpoint)
    }

    func fetchFilteredProducts(
        source: CollectionProductsSource,
        criteria: ProductFilterCriteria,
        limit: Int
    ) async throws -> ProductsResponse {
        var apiCriteria = criteria

        switch source {
        case .all:
            let endpoint = ApiEndpoint.filteredProducts(
                criteria: apiCriteria,
                limit: limit
            )
            return try await apiManager.sendRequest(from: endpoint)
        case .category(let collectionId):
            let endpoint = ApiEndpoint.filteredProducts(
                criteria: apiCriteria,
                collectionId: collectionId,
                limit: limit
            )
            return try await apiManager.sendRequest(from: endpoint)
        case .brand(let vendor):
            if apiCriteria.vendor == nil {
                apiCriteria.vendor = vendor
            }
            let endpoint = ApiEndpoint.filteredProducts(
                criteria: apiCriteria,
                limit: limit
            )
            return try await apiManager.sendRequest(from: endpoint)
        }
    }
    
    func fetchCategories() async throws -> CategoryResponse {
        let endpoint = ApiEndpoint.categories()
        return try await apiManager.sendRequest(from: endpoint)
    }
    
    func fetchBrands() async throws -> BrandResponse {
        let endpoint = ApiEndpoint.brands()
        return try await apiManager.sendRequest(from: endpoint)
    }
}
