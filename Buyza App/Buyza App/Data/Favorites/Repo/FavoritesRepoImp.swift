//
//  FavoritesRepoImp.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import Foundation

struct FavoritesRepoImp : FavoritesRepoProtocol {
    private let localDataSource: ProductLocalDataSourceProtocol
    
    init(
        localDataSource: ProductLocalDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
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
    
    func getFavoriteProducts() throws -> [Product] {
        try localDataSource.getFavoriteProducts()
    }
}
