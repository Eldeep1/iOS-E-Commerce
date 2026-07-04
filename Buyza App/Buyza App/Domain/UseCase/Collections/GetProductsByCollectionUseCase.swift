//
//  GetProductsByCollectionUseCase.swift
//  Buyza App
//

import Foundation

protocol GetProductsByCollectionUseCaseProtocol {
    func execute(collectionId: Int) async throws -> [Product]
}

struct GetProductsByCollectionUseCase: GetProductsByCollectionUseCaseProtocol {
    private let repository: CollectionRepoProtocol
    
    init(repository: CollectionRepoProtocol) {
        self.repository = repository
    }
    
    func execute(collectionId: Int) async throws -> [Product] {
        let response = try await repository.fetchCollectionProducts(collectionId: collectionId)
        return response.products
    }
}
