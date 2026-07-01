//
//  AddressRepositoryProtocol.swift
//  Buyza App
//

import Foundation

protocol AddressRepositoryProtocol {
    func fetchAddresses() async throws -> [Address]
    func addAddress(_ address: Address) async throws -> Address
    func updateAddress(_ address: Address) async throws -> Address
    func deleteAddress(id: String) async throws
}
