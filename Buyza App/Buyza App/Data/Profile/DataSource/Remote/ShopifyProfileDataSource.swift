//
//  ShopifyProfileDataSource.swift
//  Buyza App
//

import Foundation

protocol ProfileDataSourceProtocol {
    func fetchProfile() async throws -> UserProfile
    func updateProfile(_ profile: UserProfile) async throws -> UserProfile
}

final class ShopifyProfileDataSource: ProfileDataSourceProtocol {
    private let apiManager: ApiManager
    private let localAuth: LocalAuthDataSourceProtocol

    init(
        apiManager: ApiManager = .shared,
        localAuth: LocalAuthDataSourceProtocol = KeychainService.shared
    ) {
        self.apiManager = apiManager
        self.localAuth = localAuth
    }

    func fetchProfile() async throws -> UserProfile {
        let token = try localAuth.getShopifyToken()

        let query = """
        query {
          customer(customerAccessToken: "\(token)") {
            id
            firstName
            lastName
            email
            phone
          }
        }
        """

        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        let body = GraphQLQuery(query: query)
        let response: FetchProfileResponse = try await apiManager.sendRequest(from: endpoint, with: body)

        guard let customer = response.data?.customer else {
            throw AuthError.firebaseError("Could not load profile data.")
        }

        return UserProfile(
            firstName: customer.firstName ?? "",
            lastName: customer.lastName ?? "",
            email: customer.email ?? "",
            phone: customer.phone ?? ""
        )
    }

    func updateProfile(_ profile: UserProfile) async throws -> UserProfile {
        let token = try localAuth.getShopifyToken()

        let mutation = """
        mutation customerUpdate($customerAccessToken: String!, $customer: CustomerUpdateInput!) {
          customerUpdate(customerAccessToken: $customerAccessToken, customer: $customer) {
            customer {
              firstName
              lastName
              email
              phone
            }
            customerUserErrors {
              field
              message
            }
          }
        }
        """

        struct CustomerUpdateInput: Encodable {
            let firstName: String
            let lastName: String
            let phone: String
        }

        struct UpdateProfileVariables: Encodable {
            let customerAccessToken: String
            let customer: CustomerUpdateInput
        }

        let variables = UpdateProfileVariables(
            customerAccessToken: token,
            customer: CustomerUpdateInput(
                firstName: profile.firstName,
                lastName: profile.lastName,
                phone: profile.phone
            )
        )

        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        let body = GraphQLRequest(query: mutation, variables: variables)
        let response: UpdateProfileResponse = try await apiManager.sendRequest(from: endpoint, with: body)

        if let error = response.data?.customerUpdate?.customerUserErrors?.first {
            throw AuthError.firebaseError(error.message)
        }

        guard let customer = response.data?.customerUpdate?.customer else {
            throw AuthError.firebaseError("Could not update profile.")
        }

        return UserProfile(
            firstName: customer.firstName ?? profile.firstName,
            lastName: customer.lastName ?? profile.lastName,
            email: customer.email ?? profile.email,
            phone: customer.phone ?? profile.phone
        )
    }
}
