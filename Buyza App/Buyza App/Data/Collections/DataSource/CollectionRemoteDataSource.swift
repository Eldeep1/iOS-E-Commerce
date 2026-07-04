//
//  CollectionRemoteDataSource.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import Foundation

protocol CollectionRemoteDataSourceProtocol {
    func fetchCollectionProducts(collectionId: Int) async throws -> ProductsResponse
    func fetchProductsByVendor(vendor: String) async throws -> ProductsResponse
}

class CollectionRemoteDataSource : CollectionRemoteDataSourceProtocol {
    private let apiManager: ApiManager
    
    init(apiManager: ApiManager = .shared) {
        self.apiManager = apiManager
    }
    
    func fetchCollectionProducts(collectionId: Int) async throws -> ProductsResponse {
        let endpoint = ApiEndpoint.collectionProducts(collectionId: collectionId)
        return try await apiManager.sendRequest(from: endpoint)
    }

    func fetchProductsByVendor(vendor: String) async throws -> ProductsResponse {
        let endpoint = ApiEndpoint.productsByVendor(vendor: vendor)
        return try await apiManager.sendRequest(from: endpoint)
    }
}
