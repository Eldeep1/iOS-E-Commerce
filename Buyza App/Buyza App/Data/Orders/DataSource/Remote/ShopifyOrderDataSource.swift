//
//  ShopifyOrderDataSource.swift
//  Buyza App
//

import Foundation

final class ShopifyOrderDataSource: OrderDataSourceProtocol {
    private let apiManager: ApiManager
    private let localAuth: LocalAuthDataSourceProtocol

    init(
        apiManager: ApiManager = .shared,
        localAuth: LocalAuthDataSourceProtocol = KeychainService.shared
    ) {
        self.apiManager = apiManager
        self.localAuth = localAuth
    }

    func fetchOrders() async throws -> [OrderDTO] {
        let token: String
        do {
            token = try localAuth.getShopifyToken()
        } catch {
            throw OrderError.notAuthenticated
        }

        let query = """
        query {
          customer(customerAccessToken: "\(token)") {
            orders(first: 50, sortKey: PROCESSED_AT, reverse: true) {
              edges {
                node {
                  id
                  orderNumber
                  name
                  processedAt
                  financialStatus
                  fulfillmentStatus
                  totalPrice {
                    amount
                    currencyCode
                  }
                  lineItems(first: 10) {
                    edges {
                      node {
                        title
                        quantity
                        originalTotalPrice {
                          amount
                          currencyCode
                        }
                        variant {
                          image {
                            url
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """

        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        let body = GraphQLQuery(query: query)
        let response: FetchOrdersResponse = try await apiManager.sendRequest(from: endpoint, with: body)

        guard let customer = response.data?.customer else {
            throw OrderError.notAuthenticated
        }

        return customer.orders?.edges.map(\.node) ?? []
    }
}
