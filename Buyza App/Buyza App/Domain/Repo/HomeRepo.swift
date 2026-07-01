//
//  HomeRepo.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 01/07/2026.
//

import Foundation

protocol HomeRepoProtocol {
    func fetchProducts(limit: Int) async throws -> ProductsResponse
    func fetchCategories() async throws -> CategoryResponse
    func fetchBrands() async throws -> BrandResponse
}
