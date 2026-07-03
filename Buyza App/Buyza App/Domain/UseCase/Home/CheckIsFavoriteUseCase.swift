//
//  CheckIsFavoriteUseCase.swift
//  Buyza App
//

import Foundation

protocol CheckIsFavoriteUseCaseProtocol {
    func execute(productId: Int64) throws -> Bool
}

struct CheckIsFavoriteUseCase: CheckIsFavoriteUseCaseProtocol {
    private let repository: ProductProtocol
    
    init(repository: ProductProtocol) {
        self.repository = repository
    }
    
    func execute(productId: Int64) throws -> Bool {
        try repository.isFavorite(productId: productId)
    }
}
