//
//  CollectionRepoImp.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import Foundation

struct CollectionRepoImp : CollectionRepoProtocol {
    private let remoteDataSource: CollectionRemoteDataSourceProtocol
    private let localDataSource: ProductLocalDataSourceProtocol
    
    init(
        remoteDataSource: CollectionRemoteDataSourceProtocol,
        localDataSource: ProductLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func fetchCollectionProducts(collectionId: Int) async throws -> ProductsResponse {
        try await remoteDataSource.fetchCollectionProducts(collectionId: collectionId)
    }

    func fetchProductsByVendor(vendor: String) async throws -> ProductsResponse {
        try await remoteDataSource.fetchProductsByVendor(vendor: vendor)
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
