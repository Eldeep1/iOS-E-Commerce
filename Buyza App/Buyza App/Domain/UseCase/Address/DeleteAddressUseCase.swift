//
//  DeleteAddressUseCase.swift
//  Buyza App
//

import Foundation

protocol DeleteAddressUseCaseProtocol {
    func execute(id: String) async throws
}

final class DeleteAddressUseCase: DeleteAddressUseCaseProtocol {
    private let repository: AddressRepositoryProtocol
    
    init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: String) async throws {
        try await repository.deleteAddress(id: id)
    }
}
