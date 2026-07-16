//
//  AddressDataSourceProtocol.swift
//  Buyza App
//

import Foundation

protocol AddressDataSourceProtocol {
    func fetchAddresses() async throws -> (addresses: [AddressDTO], defaultAddressId: String?)
    func addAddress(firstName: String, lastName: String, phone: String, address1: String, city: String, province: String, zip: String, country: String) async throws -> AddressDTO
    func updateAddress(id: String, firstName: String, lastName: String, phone: String, address1: String, city: String, province: String, zip: String, country: String) async throws -> AddressDTO
    func deleteAddress(id: String) async throws
    func updateDefaultAddress(addressId: String) async throws
}
