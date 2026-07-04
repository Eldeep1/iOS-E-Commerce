//
//  GetProductsByVendorUseCase.swift
//  Buyza App
//

import Foundation

protocol GetProductsByVendorUseCaseProtocol {
    func execute(vendor: String) async throws -> [Product]
}

struct GetProductsByVendorUseCase: GetProductsByVendorUseCaseProtocol {
    private let repository: CollectionRepoProtocol
    
    init(repository: CollectionRepoProtocol) {
        self.repository = repository
    }
    
    func execute(vendor: String) async throws -> [Product] {
        let response = try await repository.fetchProductsByVendor(vendor: vendor)
        return response.products
    }
}
