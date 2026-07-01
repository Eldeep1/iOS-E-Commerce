//
//  HomeRemoteDataSource.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 01/07/2026.
//

import Foundation

protocol HomeRemoteDataSourceProtocol {
    func fetchProducts(limit: Int) async throws -> ProductsResponse
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
    
    func fetchCategories() async throws -> CategoryResponse {
        let endpoint = ApiEndpoint.categories()
        return try await apiManager.sendRequest(from: endpoint)
    }
    
    func fetchBrands() async throws -> BrandResponse {
        let endpoint = ApiEndpoint.brands()
        return try await apiManager.sendRequest(from: endpoint)
    }
}
