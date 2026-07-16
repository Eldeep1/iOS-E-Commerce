//
//  AddAddressUseCase.swift
//  Buyza App
//

import Foundation

protocol AddAddressUseCaseProtocol {
    func execute(address: Address) async throws -> Address
}

final class AddAddressUseCase: AddAddressUseCaseProtocol {
    private let repository: AddressRepositoryProtocol
    
    init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(address: Address) async throws -> Address {
        // Enforce business logic if needed (e.g. formatting phone number) before sending to Data Layer
        return try await repository.addAddress(address)
    }
}
