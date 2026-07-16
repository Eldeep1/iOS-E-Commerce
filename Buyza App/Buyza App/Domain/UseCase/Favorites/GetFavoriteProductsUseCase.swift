//
//  GetFavoriteProductsUseCase.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import Foundation

protocol GetFavoriteProductsUseCaseProtocol {
    func execute() throws -> [Product]
}
struct GetFavoriteProductsUseCase: GetFavoriteProductsUseCaseProtocol {
    private let repository: FavoritesRepoProtocol
    
    init(repository: FavoritesRepoProtocol) {
        self.repository = repository
    }
    
    func execute() throws -> [Product] {
        try repository.getFavoriteProducts()
    }
}
