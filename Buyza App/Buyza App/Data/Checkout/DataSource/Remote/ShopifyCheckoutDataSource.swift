//
//  ShopifyCheckoutDataSource.swift
//  Buyza App
//

import Foundation

protocol CheckoutDataSourceProtocol {
    func getCheckoutURL(cartID: String) async throws -> CheckoutSummary
    func applyDiscount(cartID: String, discountCode: String) async throws -> CheckoutSummary
    func updateBuyerIdentity(cartID: String, addressID: String, customerAccessToken: String) async throws -> String
}

final class ShopifyCheckoutDataSource: CheckoutDataSourceProtocol {
    
    // We fetch the cart to get its checkout URL and cost summary
    func getCheckoutURL(cartID: String) async throws -> CheckoutSummary {
        let query = """
        query getCart($id: ID!) {
          cart(id: $id) {
            id
            checkoutUrl
            cost {
              subtotalAmount { amount }
              totalAmount { amount }
              totalTaxAmount { amount }
            }
          }
        }
        """
        
        struct CartVariables: Encodable {
            let id: String
        }
        
        let variables = CartVariables(id: cartID)
        let request = GraphQLRequest(query: query, variables: variables)
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        let response: GraphQLResponse<CartQueryResponse> = try await ApiManager.shared.sendRequest(from: endpoint, with: request)
        
        guard let cart = response.data?.cart, let webUrl = URL(string: cart.checkoutUrl) else {
            throw NSError(domain: "CheckoutError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Cart not found or invalid URL"])
        }
        
        let subtotal = Double(cart.cost.subtotalAmount.amount) ?? 0.0
        let total = Double(cart.cost.totalAmount.amount) ?? 0.0
        
        let diff = total - subtotal
        let shipping = diff > 0 ? diff : 0.0
        let discount = diff < 0 ? abs(diff) : 0.0
        
        return CheckoutSummary(
            id: cart.id,
            webUrl: webUrl,
            subtotal: subtotal,
            shipping: shipping,
            discount: discount,
            total: total
        )
    }
    
    func applyDiscount(cartID: String, discountCode: String) async throws -> CheckoutSummary {
        let mutation = """
        mutation cartDiscountCodesUpdate($cartId: ID!, $discountCodes: [String!]!) {
          cartDiscountCodesUpdate(cartId: $cartId, discountCodes: $discountCodes) {
            cart {
              id
              checkoutUrl
              cost {
                subtotalAmount { amount }
                totalAmount { amount }
              }
            }
            userErrors {
              message
            }
          }
        }
        """
        
        struct CartDiscountVariables: Encodable {
            let cartId: String
            let discountCodes: [String]
        }
        
        let codes = discountCode.isEmpty ? [String]() : [discountCode]
        let variables = CartDiscountVariables(cartId: cartID, discountCodes: codes)
        
        let request = GraphQLRequest(query: mutation, variables: variables)
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        let response: GraphQLResponse<CartDiscountResponse> = try await ApiManager.shared.sendRequest(from: endpoint, with: request)
        
        if let error = response.data?.cartDiscountCodesUpdate.userErrors.first {
            throw NSError(domain: "CheckoutError", code: 400, userInfo: [NSLocalizedDescriptionKey: error.message])
        }
        
        guard let cart = response.data?.cartDiscountCodesUpdate.cart, let webUrl = URL(string: cart.checkoutUrl) else {
            throw NSError(domain: "CheckoutError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Cart not found"])
        }
        
        let subtotal = Double(cart.cost.subtotalAmount.amount) ?? 0.0
        let total = Double(cart.cost.totalAmount.amount) ?? 0.0
        
        let diff = total - subtotal
        let shipping = diff > 0 ? diff : 0.0
        let discount = diff < 0 ? abs(diff) : 0.0
        
        return CheckoutSummary(
            id: cart.id,
            webUrl: webUrl,
            subtotal: subtotal,
            shipping: shipping,
            discount: discount,
            total: total
        )
    }
    
    func updateBuyerIdentity(cartID: String, addressID: String, customerAccessToken: String) async throws -> String {
        let mutation = """
        mutation cartBuyerIdentityUpdate($cartId: ID!, $buyerIdentity: CartBuyerIdentityInput!) {
          cartBuyerIdentityUpdate(cartId: $cartId, buyerIdentity: $buyerIdentity) {
            cart {
              id
            }
            userErrors {
              message
            }
          }
        }
        """
        
        struct CartBuyerIdentityVariables: Encodable {
            struct BuyerIdentityInput: Encodable {
                let customerAccessToken: String
                let deliveryAddressPreferences: [DeliveryAddressPref]
            }
            struct DeliveryAddressPref: Encodable {
                let customerAddressId: String
            }
            
            let cartId: String
            let buyerIdentity: BuyerIdentityInput
        }
        
        let prefs = [CartBuyerIdentityVariables.DeliveryAddressPref(customerAddressId: addressID)]
        let identity = CartBuyerIdentityVariables.BuyerIdentityInput(customerAccessToken: customerAccessToken, deliveryAddressPreferences: prefs)
        let variables = CartBuyerIdentityVariables(cartId: cartID, buyerIdentity: identity)
        
        let request = GraphQLRequest(query: mutation, variables: variables)
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        let response: GraphQLResponse<CartBuyerIdentityResponse> = try await ApiManager.shared.sendRequest(from: endpoint, with: request)
        
        if let error = response.data?.cartBuyerIdentityUpdate.userErrors.first {
            throw NSError(domain: "CheckoutError", code: 400, userInfo: [NSLocalizedDescriptionKey: error.message])
        }
        
        return response.data?.cartBuyerIdentityUpdate.cart?.id ?? cartID
    }
}

