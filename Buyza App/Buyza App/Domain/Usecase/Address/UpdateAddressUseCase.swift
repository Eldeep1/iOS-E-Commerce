//
//  UpdateAddressUseCase.swift
//  Buyza App
//

import Foundation

protocol UpdateAddressUseCaseProtocol {
    func execute(address: Address) async throws -> Address
}

final class UpdateAddressUseCase: UpdateAddressUseCaseProtocol {
    private let repository: AddressRepositoryProtocol
    
    init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(address: Address) async throws -> Address {
        return try await repository.updateAddress(address)
    }
}
