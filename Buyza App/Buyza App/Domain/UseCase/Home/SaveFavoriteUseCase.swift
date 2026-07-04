//
//  SaveFavoriteUseCase.swift
//  Buyza App
//

import Foundation

protocol SaveFavoriteUseCaseProtocol {
    func execute(product: Product) throws
}

struct SaveFavoriteUseCase: SaveFavoriteUseCaseProtocol {
    private let repository: ProductProtocol
    
    init(repository: ProductProtocol) {
        self.repository = repository
    }
    
    func execute(product: Product) throws {
        try repository.saveProduct(product: product)
    }
}
