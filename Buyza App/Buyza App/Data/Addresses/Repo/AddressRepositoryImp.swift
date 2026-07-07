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
        return Address(
            id: dto.id,
            firstName: dto.firstName ?? "",
            lastName: dto.lastName ?? "",
            phoneNumber: dto.phone ?? "",
            streetAddress: dto.address1 ?? "",
            city: dto.city ?? "",
            province: dto.province ?? "",
            zip: dto.zip ?? "",
            country: dto.country ?? "",
            isDefault: isDefault
        )
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
        let dto = try await remoteDataSource.addAddress(
            firstName: address.firstName,
            lastName: address.lastName,
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
        let dto = try await remoteDataSource.updateAddress(
            id: address.id,
            firstName: address.firstName,
            lastName: address.lastName,
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
