//
//  AddressRepositoryImp.swift
//  Buyza App
//

import Foundation

final class AddressRepositoryImp: AddressRepositoryProtocol {
    private let remoteDataSource: AddressDataSourceProtocol
    
    init(remoteDataSource: AddressDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - Mapping Helpers
    
    private func map(dto: AddressDTO, isDefault: Bool) -> Address {
        let fullName = [dto.firstName, dto.lastName]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        
        return Address(
            id: dto.id,
            fullName: fullName.isEmpty ? "Unknown Name" : fullName,
            phoneNumber: dto.phone ?? "",
            streetAddress: dto.address1 ?? "",
            city: dto.city ?? "",
            province: dto.province ?? "",
            zip: dto.zip ?? "",
            country: dto.country ?? "",
            isDefault: isDefault
        )
    }
    
    private func split(fullName: String) -> (firstName: String, lastName: String) {
        let components = fullName.split(separator: " ")
        guard !components.isEmpty else { return ("", "") }
        
        let firstName = String(components.first!)
        let lastName = components.dropFirst().joined(separator: " ")
        return (firstName, lastName)
    }
    
    // MARK: - AddressRepositoryProtocol
    
    func fetchAddresses() async throws -> [Address] {
        let response = try await remoteDataSource.fetchAddresses()
        let defaultId = response.defaultAddressId
        
        return response.addresses.map { dto in
            map(dto: dto, isDefault: dto.id == defaultId)
        }
    }
    
    func addAddress(_ address: Address) async throws -> Address {
        let names = split(fullName: address.fullName)
        
        let dto = try await remoteDataSource.addAddress(
            firstName: names.firstName,
            lastName: names.lastName,
            phone: address.phoneNumber,
            address1: address.streetAddress,
            city: address.city,
            province: address.province,
            zip: address.zip,
            country: address.country
        )
        
        if address.isDefault {
            try await remoteDataSource.updateDefaultAddress(addressId: dto.id)
        }
        
        return map(dto: dto, isDefault: address.isDefault)
    }
    
    func updateAddress(_ address: Address) async throws -> Address {
        let names = split(fullName: address.fullName)
        
        let dto = try await remoteDataSource.updateAddress(
            id: address.id,
            firstName: names.firstName,
            lastName: names.lastName,
            phone: address.phoneNumber,
            address1: address.streetAddress,
            city: address.city,
            province: address.province,
            zip: address.zip,
            country: address.country
        )
        
        if address.isDefault {
            try await remoteDataSource.updateDefaultAddress(addressId: dto.id)
        }
        
        return map(dto: dto, isDefault: address.isDefault)
    }
    
    func deleteAddress(id: String) async throws {
        try await remoteDataSource.deleteAddress(id: id)
    }
}
