//
//  Untitled.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//

protocol CartDataSourceProtocol {
    func createCart(variantID: String, quantity: Int) async throws -> Cart
    func fetchCart(cartID: String) async throws -> Cart
    func addLines(cartID: String, variantID: String, quantity: Int) async throws -> Cart
    func updateLine(cartID: String, lineID: String, quantity: Int) async throws -> Cart
    func removeLine(cartID: String, lineID: String) async throws -> Cart
}

final class ShopifyCartDataSource: CartDataSourceProtocol {
    
    private let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
    
    func createCart(variantID: String, quantity: Int) async throws -> Cart {
        let mutation = """
        mutation cartCreate($input: CartInput!) {
          cartCreate(input: $input) {
            cart { ...CartFragment }
            userErrors { field message }
          }
        }
        \(Self.cartFragment)
        """
        struct Vars: Encodable {
            struct Input: Encodable {
                struct Line: Encodable { let merchandiseId: String; let quantity: Int }
                let lines: [Line]
            }
            let input: Input
        }
        let vars = Vars(input: .init(lines: [.init(merchandiseId: variantID, quantity: quantity)]))

        let response: GraphQLResponse<CartCreateData> = try await ApiManager.shared.sendRequest(from: endpoint, with: GraphQLRequest(query: mutation, variables: vars))

        // Check top-level GraphQL errors (auth, schema issues)
        if let topError = response.errors?.first {
            throw CartError.networkError("GraphQL Error: \(topError.message)")
        }
        if let errors = response.data?.cartCreate.userErrors, let firstError = errors.first {
            throw CartError.networkError("Shopify Error: \(firstError.message)")
        }
        guard let cart = response.data?.cartCreate.cart else { throw CartError.networkError("cartCreate returned nil") }
        return cart
    }
    func fetchCart(cartID: String) async throws -> Cart {
        let query = """
        query getCart($id: ID!) {
          cart(id: $id) { ...CartFragment }
        }
        \(Self.cartFragment)
        """
        struct Vars: Encodable { let id: String }
        let response: GraphQLResponse<CartQueryData> = try await ApiManager.shared.sendRequest(from: endpoint, with: GraphQLRequest(query: query, variables: Vars(id: cartID)))
        guard let cart = response.data?.cart else { throw CartError.cartNotFound }
        return cart
    }
    func addLines(cartID: String, variantID: String, quantity: Int) async throws -> Cart {
        let mutation = """
        mutation cartLinesAdd($cartId: ID!, $lines: [CartLineInput!]!) {
          cartLinesAdd(cartId: $cartId, lines: $lines) {
            cart { ...CartFragment }
            userErrors { field message }
          }
        }
        \(Self.cartFragment)
        """
        struct Vars: Encodable {
            struct Line: Encodable { let merchandiseId: String; let quantity: Int }
            let cartId: String; let lines: [Line]
        }
        let response: GraphQLResponse<CartLinesAddData> = try await ApiManager.shared.sendRequest(from: endpoint, with: GraphQLRequest(query: mutation, variables: Vars(cartId: cartID, lines: [.init(merchandiseId: variantID, quantity: quantity)])))
        if let errors = response.data?.cartLinesAdd.userErrors, let firstError = errors.first {
            throw CartError.networkError("Shopify Error: \\(firstError.message)")
        }
        guard let cart = response.data?.cartLinesAdd.cart else { throw CartError.networkError("cartLinesAdd failed") }
        return cart
    }
    func updateLine(cartID: String, lineID: String, quantity: Int) async throws -> Cart {
        let mutation = """
        mutation cartLinesUpdate($cartId: ID!, $lines: [CartLineUpdateInput!]!) {
          cartLinesUpdate(cartId: $cartId, lines: $lines) {
            cart { ...CartFragment }
            userErrors { field message }
          }
        }
        \(Self.cartFragment)
        """
        struct Vars: Encodable {
            struct Line: Encodable { let id: String; let quantity: Int }
            let cartId: String; let lines: [Line]
        }
        let response: GraphQLResponse<CartLinesUpdateData> = try await ApiManager.shared.sendRequest(from: endpoint, with: GraphQLRequest(query: mutation, variables: Vars(cartId: cartID, lines: [.init(id: lineID, quantity: quantity)])))
        if let errors = response.data?.cartLinesUpdate.userErrors, let firstError = errors.first {
            throw CartError.networkError("Shopify Error: \\(firstError.message)")
        }
        guard let cart = response.data?.cartLinesUpdate.cart else { throw CartError.networkError("cartLinesUpdate failed") }
        return cart
    }
    func removeLine(cartID: String, lineID: String) async throws -> Cart {
        let mutation = """
        mutation cartLinesRemove($cartId: ID!, $lineIds: [ID!]!) {
          cartLinesRemove(cartId: $cartId, lineIds: $lineIds) {
            cart { ...CartFragment }
            userErrors { field message }
          }
        }
        \(Self.cartFragment)
        """
        struct Vars: Encodable { let cartId: String; let lineIds: [String] }
        let response: GraphQLResponse<CartLinesRemoveData> = try await ApiManager.shared.sendRequest(from: endpoint, with: GraphQLRequest(query: mutation, variables: Vars(cartId: cartID, lineIds: [lineID])))
        if let errors = response.data?.cartLinesRemove.userErrors, let firstError = errors.first {
            throw CartError.networkError("Shopify Error: \\(firstError.message)")
        }
        guard let cart = response.data?.cartLinesRemove.cart else { throw CartError.networkError("cartLinesRemove failed") }
        return cart
    }
    // MARK: - Shared Fragment
    private static let cartFragment = """
    fragment CartFragment on Cart {
      id
      lines(first: 50) {
        edges {
          node {
            id
            quantity
            cost { totalAmount { amount currencyCode } }
            merchandise {
              ... on ProductVariant {
                id
                title
                product {
                  title
                  vendor
                  featuredImage { url }
                }
              }
            }
          }
        }
      }
      cost {
        subtotalAmount { amount currencyCode }
        totalAmount { amount currencyCode }
      }
    }
    """
}
