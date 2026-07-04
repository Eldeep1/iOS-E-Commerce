//
//  GetBrandsUseCase.swift
//  Buyza App
//

import Foundation

protocol GetBrandsUseCaseProtocol {
    func execute() async throws -> [Collection]
}

struct GetBrandsUseCase: GetBrandsUseCaseProtocol {
    private let repository: HomeRepoProtocol
    
    init(repository: HomeRepoProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Collection] {
        let response = try await repository.fetchBrands()
        return response.smart_collections ?? []
    }
}
