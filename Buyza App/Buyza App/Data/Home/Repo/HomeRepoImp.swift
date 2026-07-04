//
//  HomeRepoImp.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 01/07/2026.
//

import Foundation

struct HomeRepoImp: HomeRepoProtocol {
    
    private let remoteDataSource: HomeRemoteDataSourceProtocol
    private let localDataSource: ProductLocalDataSourceProtocol
    
    init(
        remoteDataSource: HomeRemoteDataSourceProtocol,
        localDataSource: ProductLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func fetchProducts(limit: Int) async throws -> ProductsResponse {
        try await remoteDataSource.fetchProducts(limit: limit)
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
    
    func saveProduct(product: Product) throws {
        try localDataSource.saveProduct(product: product)
    }
    
    func removeProduct(productId: Int64) throws {
        try localDataSource.removeProduct(productId: productId)
    }
    
    func isFavorite(productId: Int64) throws -> Bool {
        try localDataSource.isFavorite(productId: productId)
    }
}
