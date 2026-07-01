//
//  GetAddressesUseCase.swift
//  Buyza App
//

import Foundation

protocol GetAddressesUseCaseProtocol {
    func execute() async throws -> [Address]
}

final class GetAddressesUseCase: GetAddressesUseCaseProtocol {
    private let repository: AddressRepositoryProtocol
    
    init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Address] {
        return try await repository.fetchAddresses()
    }
}
