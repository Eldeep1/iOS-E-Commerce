//
//  HomeUseCase.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 01/07/2026.
//

import Foundation

protocol HomeUseCaseProtocol {
    func getRecommendedProducts() async throws -> [Product]
    func getProducts(collectionId: Int) async throws -> [Product]
    func getProductsByVendor(vendor: String) async throws -> [Product]
    func getCategories() async throws -> [Collection]
    func getBrands() async throws -> [Collection]
}

struct HomeUseCase: HomeUseCaseProtocol {
    
    private let homeRepo: HomeRepoProtocol
    
    init(homeRepo: HomeRepoProtocol) {
        self.homeRepo = homeRepo
    }
    
    func getRecommendedProducts() async throws -> [Product] {
        let response = try await homeRepo.fetchProducts(limit: 8)
        return response.products
    }

    func getProducts(collectionId: Int) async throws -> [Product] {
        let response = try await homeRepo.fetchCollectionProducts(collectionId: collectionId)
        return response.products
    }

    func getProductsByVendor(vendor: String) async throws -> [Product] {
        let response = try await homeRepo.fetchProductsByVendor(vendor: vendor)
        return response.products
    }
    
    func getCategories() async throws -> [Collection] {
        let response = try await homeRepo.fetchCategories()
        return response.custom_collections ?? []
    }
    
    func getBrands() async throws -> [Collection] {
        let response = try await homeRepo.fetchBrands()
        return response.smart_collections ?? []
    }
}
