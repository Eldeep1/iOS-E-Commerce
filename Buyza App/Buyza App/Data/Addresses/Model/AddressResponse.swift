//
//  AddressResponse.swift
//  Buyza App
//

import Foundation

// MARK: - Address DTO
struct AddressDTO: Decodable {
    let id: String
    let firstName: String?
    let lastName: String?
    let phone: String?
    let address1: String?
    let city: String?
    let country: String?
}

// MARK: - GraphQL Errors
struct AddressUserError: Decodable {
    let field: [String]?
    let message: String
}

// MARK: - Fetch Addresses
struct FetchAddressesResponse: Decodable {
    let data: FetchAddressesData?
}

struct FetchAddressesData: Decodable {
    let customer: CustomerData?
}

struct CustomerData: Decodable {
    let addresses: AddressConnection?
    // In Shopify, the customer object also has a defaultAddress field we can use
    let defaultAddress: AddressDTO?
}

struct AddressConnection: Decodable {
    let edges: [AddressEdge]
}

struct AddressEdge: Decodable {
    let node: AddressDTO
}

// MARK: - Create Address
struct CreateAddressResponse: Decodable {
    let data: CreateAddressData?
}

struct CreateAddressData: Decodable {
    let customerAddressCreate: CustomerAddressPayload?
}

// MARK: - Update Address
struct UpdateAddressResponse: Decodable {
    let data: UpdateAddressData?
}

struct UpdateAddressData: Decodable {
    let customerAddressUpdate: CustomerAddressPayload?
}

struct CustomerAddressPayload: Decodable {
    let customerAddress: AddressDTO?
    let customerUserErrors: [AddressUserError]?
}

// MARK: - Delete Address
struct DeleteAddressResponse: Decodable {
    let data: DeleteAddressData?
}

struct DeleteAddressData: Decodable {
    let customerAddressDelete: CustomerAddressDeletePayload?
}

struct CustomerAddressDeletePayload: Decodable {
    let deletedCustomerAddressId: String?
    let customerUserErrors: [AddressUserError]?
}
