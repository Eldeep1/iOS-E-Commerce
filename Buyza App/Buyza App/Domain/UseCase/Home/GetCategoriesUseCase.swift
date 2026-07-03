//
//  GetCategoriesUseCase.swift
//  Buyza App
//

import Foundation

protocol GetCategoriesUseCaseProtocol {
    func execute() async throws -> [Collection]
}

struct GetCategoriesUseCase: GetCategoriesUseCaseProtocol {
    private let repository: HomeRepoProtocol
    
    init(repository: HomeRepoProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Collection] {
        let response = try await repository.fetchCategories()
        return response.custom_collections ?? []
    }
}
