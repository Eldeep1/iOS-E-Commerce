//
//  HomeRepo.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 01/07/2026.
//

import Foundation

protocol ProductProtocol {
    func saveProduct(product: Product) throws
    func removeProduct(productId: Int64) throws
    func isFavorite(productId: Int64) throws -> Bool
}

protocol HomeRepoProtocol : ProductProtocol {
    func fetchProducts(limit: Int) async throws -> ProductsResponse
    func fetchCategories() async throws -> CategoryResponse
    func fetchBrands() async throws -> BrandResponse
}
