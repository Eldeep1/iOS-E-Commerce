//
//  RemoveFavoriteUseCase.swift
//  Buyza App
//

import Foundation

protocol RemoveFavoriteUseCaseProtocol {
    func execute(productId: Int64) throws
}

struct RemoveFavoriteUseCase: RemoveFavoriteUseCaseProtocol {
    private let repository: ProductProtocol
    
    init(repository: ProductProtocol) {
        self.repository = repository
    }
    
    func execute(productId: Int64) throws {
        try repository.removeProduct(productId: productId)
    }
}
