//
//  ShopifyAuthService.swift
//  Buyza App
//
//  Created by depo on 29/06/2026.
//

import Foundation

protocol ShopifyAuthServiceProtocol {
    func createCustomer(email: String, password: String) async throws -> String
    func getCustomerID(email: String, password: String) async throws -> String
    
}

final class ShopifyAuthService: ShopifyAuthServiceProtocol {
    
    func createCustomer(email: String, password: String) async throws -> String {
        
        let mutation = """
        mutation customerCreate($input: CustomerCreateInput!) {
          customerCreate(input: $input) {
            customer {
              id
            }
            customerUserErrors {
              field
              message
            }
          }
        }
        """
        
        let variables = CustomerVariables(
            input: CustomerCreateInputData(
                email: email,
                password: password
            )
        )
        
        let requestBody = GraphQLRequest(query: mutation, variables: variables)
        
        
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        do {
            let response: GraphQLResponse<CustomerCreateResponse> = try await ApiManager.shared.sendRequest(
                from: endpoint,
                with: requestBody
            )
            
            if let topLevelError = response.errors?.first {
                print("GraphQL Top-Level Error: \(topLevelError.message)")
                throw NSError(domain: "ShopifyError", code: 401, userInfo: [NSLocalizedDescriptionKey: topLevelError.message])
            }
            
            guard let responseData = response.data else {
                print("Data was missing from the response entirely.")
                throw NSError(domain: "ShopifyError", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
            }
            
            if let userError = responseData.customerCreate.customerUserErrors.first {
                print("Shopify User Error: \(userError.message)")
                throw NSError(domain: "ShopifyError", code: 400, userInfo: [NSLocalizedDescriptionKey: userError.message])
            }
            
            guard let customerId = responseData.customerCreate.customer?.id else {
                print("Customer ID was missing in the success response.")
                throw NSError(domain: "ShopifyError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to get Customer ID"])
            }
            
            return customerId
            
        } catch {
            print(" Catch block error: \(error)")
            throw error
        }
    }
    
    
    func getCustomerID(email: String, password: String) async throws -> String {
        let accessToken = try await getAccessToken(email: email, password: password)
        
        return try await fetchCustomerID(accessToken: accessToken)
    }
    
    private func getAccessToken(email: String, password: String) async throws -> String {
        let mutation = """
        mutation customerAccessTokenCreate($input: CustomerAccessTokenCreateInput!) {
          customerAccessTokenCreate(input: $input) {
            customerAccessToken {
              accessToken
            }
            customerUserErrors {
              message
            }
          }
        }
        """
        
        let variables = CustomerAccessTokenVariables(
            input: CustomerAccessTokenInput(email: email, password: password)
        )
        
        let requestBody = GraphQLRequest(query: mutation, variables: variables)
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        let response: GraphQLResponse<CustomerAccessTokenResponse> = try await ApiManager.shared.sendRequest(
            from: endpoint,
            with: requestBody
        )
        
        if let error = response.data?.customerAccessTokenCreate.customerUserErrors.first {
            throw NSError(domain: "ShopifyError", code: 401, userInfo: [NSLocalizedDescriptionKey: error.message])
        }
        
        guard let token = response.data?.customerAccessTokenCreate.customerAccessToken?.accessToken else {
            throw NSError(domain: "ShopifyError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
        }
        
        return token
    }
    
    private func fetchCustomerID(accessToken: String) async throws -> String {
        let query = """
        query getCustomer($customerAccessToken: String!) {
          customer(customerAccessToken: $customerAccessToken) {
            id
          }
        }
        """
        
        
        struct TokenVariables: Encodable { let customerAccessToken: String }
        
        let requestBody = GraphQLRequest(query: query, variables: TokenVariables(customerAccessToken: accessToken))
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        let response: GraphQLResponse<CustomerByTokenResponse> = try await ApiManager.shared.sendRequest(
            from: endpoint,
            with: requestBody
        )
        
        guard let customerID = response.data?.customer?.id else {
            throw NSError(domain: "ShopifyError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Customer not found"])
        }
        
        return customerID
    }
}
