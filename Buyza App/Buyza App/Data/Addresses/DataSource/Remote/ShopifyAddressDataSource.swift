//
//  ShopifyAddressDataSource.swift
//  Buyza App
//

import Foundation

final class ShopifyAddressDataSource: AddressDataSourceProtocol {
    private let apiManager: ApiManager
    private let localAuth: LocalAuthDataSourceProtocol
    
    // MARK: - Variables Structs
    
    private struct MailingAddressInput: Encodable {
        let firstName: String
        let lastName: String
        let phone: String
        let address1: String
        let city: String
        let country: String
    }
    
    private struct AddAddressVariables: Encodable {
        let customerAccessToken: String
        let address: MailingAddressInput
    }
    
    private struct UpdateAddressVariables: Encodable {
        let customerAccessToken: String
        let id: String
        let address: MailingAddressInput
    }
    
    private struct DeleteAddressVariables: Encodable {
        let customerAccessToken: String
        let id: String
    }
    
    // MARK: - Lifecycle
    
    init(apiManager: ApiManager = .shared, localAuth: LocalAuthDataSourceProtocol = KeychainService.shared) {
        self.apiManager = apiManager
        self.localAuth = localAuth
    }
    
    private func getAccessToken() throws -> String {
        return try localAuth.getShopifyID()
    }
    
    func fetchAddresses() async throws -> (addresses: [AddressDTO], defaultAddressId: String?) {
        let token = try getAccessToken()
        
        let query = """
        query {
          customer(customerAccessToken: "\(token)") {
            defaultAddress {
              id
            }
            addresses(first: 50) {
              edges {
                node {
                  id
                  firstName
                  lastName
                  phone
                  address1
                  city
                  country
                }
              }
            }
          }
        }
        """
        
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        let body = GraphQLQuery(query: query)
        
        let response: FetchAddressesResponse = try await apiManager.sendRequest(from: endpoint, with: body)
        
        let defaultId = response.data?.customer?.defaultAddress?.id
        let addresses = response.data?.customer?.addresses?.edges.map { $0.node } ?? []
        return (addresses, defaultId)
    }
    
    func addAddress(firstName: String, lastName: String, phone: String, address1: String, city: String, country: String) async throws -> AddressDTO {
        let token = try getAccessToken()
        
        let mutation = """
        mutation customerAddressCreate($customerAccessToken: String!, $address: MailingAddressInput!) {
          customerAddressCreate(customerAccessToken: $customerAccessToken, address: $address) {
            customerAddress {
              id
              firstName
              lastName
              phone
              address1
              city
              country
            }
            customerUserErrors {
              field
              message
            }
          }
        }
        """
        
        let variables = AddAddressVariables(
            customerAccessToken: token,
            address: MailingAddressInput(
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                address1: address1,
                city: city,
                country: country
            )
        )
        
        let body = GraphQLRequest(query: mutation, variables: variables)
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        let response: CreateAddressResponse = try await apiManager.sendRequest(from: endpoint, with: body)
        
        if let errors = response.data?.customerAddressCreate?.customerUserErrors, !errors.isEmpty {
            throw NSError(domain: "ShopifyAddressError", code: 400, userInfo: [NSLocalizedDescriptionKey: errors.first?.message ?? "Failed to create address"])
        }
        
        guard let address = response.data?.customerAddressCreate?.customerAddress else {
            throw NSError(domain: "ShopifyAddressError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
        }
        
        return address
    }
    
    func updateAddress(id: String, firstName: String, lastName: String, phone: String, address1: String, city: String, country: String) async throws -> AddressDTO {
        let token = try getAccessToken()
        
        let mutation = """
        mutation customerAddressUpdate($customerAccessToken: String!, $id: ID!, $address: MailingAddressInput!) {
          customerAddressUpdate(customerAccessToken: $customerAccessToken, id: $id, address: $address) {
            customerAddress {
              id
              firstName
              lastName
              phone
              address1
              city
              country
            }
            customerUserErrors {
              field
              message
            }
          }
        }
        """
        
        let variables = UpdateAddressVariables(
            customerAccessToken: token,
            id: id,
            address: MailingAddressInput(
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                address1: address1,
                city: city,
                country: country
            )
        )
        
        let body = GraphQLRequest(query: mutation, variables: variables)
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        let response: UpdateAddressResponse = try await apiManager.sendRequest(from: endpoint, with: body)
        
        if let errors = response.data?.customerAddressUpdate?.customerUserErrors, !errors.isEmpty {
            throw NSError(domain: "ShopifyAddressError", code: 400, userInfo: [NSLocalizedDescriptionKey: errors.first?.message ?? "Failed to update address"])
        }
        
        guard let address = response.data?.customerAddressUpdate?.customerAddress else {
            throw NSError(domain: "ShopifyAddressError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
        }
        
        return address
    }
    
    func deleteAddress(id: String) async throws {
        let token = try getAccessToken()
        
        let mutation = """
        mutation customerAddressDelete($customerAccessToken: String!, $id: ID!) {
          customerAddressDelete(customerAccessToken: $customerAccessToken, id: $id) {
            deletedCustomerAddressId
            customerUserErrors {
              field
              message
            }
          }
        }
        """
        
        let variables = DeleteAddressVariables(customerAccessToken: token, id: id)
        let body = GraphQLRequest(query: mutation, variables: variables)
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        let response: DeleteAddressResponse = try await apiManager.sendRequest(from: endpoint, with: body)
        
        if let errors = response.data?.customerAddressDelete?.customerUserErrors, !errors.isEmpty {
            throw NSError(domain: "ShopifyAddressError", code: 400, userInfo: [NSLocalizedDescriptionKey: errors.first?.message ?? "Failed to delete address"])
        }
    }
}
