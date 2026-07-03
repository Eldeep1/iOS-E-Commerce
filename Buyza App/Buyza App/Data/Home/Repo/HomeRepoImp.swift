//
//  HomeRepoImp.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 01/07/2026.
//

import Foundation

struct HomeRepoImp: HomeRepoProtocol {
    
    private let remoteDataSource: HomeRemoteDataSourceProtocol
    
    init(remoteDataSource: HomeRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchProducts(limit: Int) async throws -> ProductsResponse {
        try await remoteDataSource.fetchProducts(limit: limit)
    }

    func fetchCollectionProducts(collectionId: Int) async throws -> ProductsResponse {
        try await remoteDataSource.fetchCollectionProducts(collectionId: collectionId)
    }

    func fetchProductsByVendor(vendor: String) async throws -> ProductsResponse {
        try await remoteDataSource.fetchProductsByVendor(vendor: vendor)
    }

    func fetchFilteredProducts(
        source: CollectionProductsSource,
        criteria: ProductFilterCriteria,
        limit: Int
    ) async throws -> ProductsResponse {
        try await remoteDataSource.fetchFilteredProducts(
            source: source,
            criteria: criteria,
            limit: limit
        )
    }
    
    func fetchCategories() async throws -> CategoryResponse {
        try await remoteDataSource.fetchCategories()
    }
    
    func fetchBrands() async throws -> BrandResponse {
        try await remoteDataSource.fetchBrands()
    }
}
