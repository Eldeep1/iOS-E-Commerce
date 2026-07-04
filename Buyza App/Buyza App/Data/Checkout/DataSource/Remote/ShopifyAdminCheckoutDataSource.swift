//
//  ShopifyAdminCheckoutDataSource.swift
//  Buyza App
//

import Foundation

final class ShopifyAdminCheckoutDataSource {

    // MARK: - Fetch Customer GID from Storefront token
    func fetchCustomerGID(accessToken: String) async throws -> String {
        let query = """
        query getCustomer($token: String!) {
          customer(customerAccessToken: $token) {
            id
          }
        }
        """
        struct Vars: Encodable { let token: String }
        let request = GraphQLRequest(query: query, variables: Vars(token: accessToken))
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        let response: GraphQLResponse<CustomerGIDResponse> = try await ApiManager.shared.sendRequest(from: endpoint, with: request)
        guard let id = response.data?.customer?.id else {
            throw NSError(domain: "CODError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Could not fetch customer ID"])
        }
        return id
    }

    // MARK: - Place COD Order (Draft Order)

    func placeCODOrder(cartID: String, address: Address, customerID: String, discountAmount: Double, discountCode: String?) async throws -> CheckoutOrder {
        let lineItems = try await fetchCartLineItems(cartID: cartID)
        
        // 2. Create Draft Order with discount
        let draftOrderId = try await createDraftOrder(address: address, customerID: customerID, lineItems: lineItems, discountAmount: discountAmount, discountCode: discountCode)

        // Step 3: Complete it as payment-pending (COD)
        return try await completeDraftOrder(draftOrderID: draftOrderId)
    }

    private func fetchCartLineItems(cartID: String) async throws -> [DraftOrderLineItemInput] {
        let query = """
        query getCartLines($id: ID!) {
          cart(id: $id) {
            lines(first: 50) {
              edges {
                node {
                  quantity
                  merchandise {
                    ... on ProductVariant {
                      id
                    }
                  }
                }
              }
            }
          }
        }
        """
        struct Vars: Encodable { let id: String }
        let request = GraphQLRequest(query: query, variables: Vars(id: cartID))
        let endpoint = ApiEndpoint(path: "/api/2024-04/graphql.json", method: .POST)
        
        let response: GraphQLResponse<CartLinesQueryResponse> = try await ApiManager.shared.sendRequest(from: endpoint, with: request)
        
        guard let cart = response.data?.cart else {
            throw NSError(domain: "CODError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Cart not found or empty"])
        }
        
        return cart.lines.edges.map { edge in
            DraftOrderLineItemInput(
                variantId: edge.node.merchandise.id,
                quantity: edge.node.quantity
            )
        }
    }

    private func createDraftOrder(address: Address, customerID: String, lineItems: [DraftOrderLineItemInput], discountAmount: Double, discountCode: String?) async throws -> String {
        let mutation = """
        mutation draftOrderCreate($input: DraftOrderInput!) {
          draftOrderCreate(input: $input) {
            draftOrder { id }
            userErrors { message }
          }
        }
        """

        struct ShippingAddress: Encodable {
            let firstName: String
            let lastName: String
            let address1: String
            let city: String
            let province: String
            let zip: String
            let country: String
            let phone: String
        }

        struct AppliedDiscountInput: Encodable {
            let description: String?
            let value: Double
            let valueType: String
        }

        struct DraftOrderInput: Encodable {
            let customerId: String
            let shippingAddress: ShippingAddress
            let useCustomerDefaultAddress: Bool
            let note: String
            let appliedDiscount: AppliedDiscountInput?
            let lineItems: [DraftOrderLineItemInput]
        }

        struct DraftOrderVariables: Encodable {
            let input: DraftOrderInput
        }

        let nameParts = address.fullName.split(separator: " ", maxSplits: 1)
        let firstName = nameParts.first.map(String.init) ?? address.fullName
        let lastName = nameParts.count > 1 ? String(nameParts[1]) : ""

        let shippingAddress = ShippingAddress(
            firstName: firstName,
            lastName: lastName,
            address1: address.streetAddress,
            city: address.city,
            province: address.province,
            zip: address.zip,
            country: address.country,
            phone: address.phoneNumber
        )

        var appliedDiscount: AppliedDiscountInput? = nil
        if discountAmount > 0 {
            appliedDiscount = AppliedDiscountInput(description: discountCode ?? "Discount", value: discountAmount, valueType: "FIXED_AMOUNT")
        }

        let input = DraftOrderInput(
            customerId: customerID,
            shippingAddress: shippingAddress,
            useCustomerDefaultAddress: false,
            note: "Cash on Delivery order placed via Buyza App",
            appliedDiscount: appliedDiscount,
            lineItems: lineItems
        )

        let variables = DraftOrderVariables(input: input)
        let request = GraphQLRequest(query: mutation, variables: variables)
        let endpoint = ApiEndpoint(
            path: "/admin/api/2024-04/graphql.json",
            method: .POST,
            headers: ApiEndpoint.adminHeaders
        )

        let response: GraphQLResponse<DraftOrderCreateResponse> = try await ApiManager.shared.sendRequest(from: endpoint, with: request)

        if let error = response.data?.draftOrderCreate.userErrors.first {
            throw NSError(domain: "CODError", code: 400, userInfo: [NSLocalizedDescriptionKey: error.message])
        }

        guard let draftID = response.data?.draftOrderCreate.draftOrder?.id else {
            throw NSError(domain: "CODError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to create draft order"])
        }

        return draftID
    }

    private func completeDraftOrder(draftOrderID: String) async throws -> CheckoutOrder {
        let mutation = """
        mutation draftOrderComplete($id: ID!, $paymentPending: Boolean) {
          draftOrderComplete(id: $id, paymentPending: $paymentPending) {
            draftOrder {
              order {
                id
                name
                totalPriceSet { shopMoney { amount } }
                displayFinancialStatus
                createdAt
              }
            }
            userErrors { message }
          }
        }
        """

        struct CompleteVariables: Encodable {
            let id: String
            let paymentPending: Bool
        }

        let variables = CompleteVariables(id: draftOrderID, paymentPending: true)
        let request = GraphQLRequest(query: mutation, variables: variables)
        let endpoint = ApiEndpoint(
            path: "/admin/api/2024-04/graphql.json",
            method: .POST,
            headers: ApiEndpoint.adminHeaders
        )

        let response: GraphQLResponse<DraftOrderCompleteResponse> = try await ApiManager.shared.sendRequest(from: endpoint, with: request)

        if let error = response.data?.draftOrderComplete.userErrors.first {
            throw NSError(domain: "CODError", code: 400, userInfo: [NSLocalizedDescriptionKey: error.message])
        }

        guard let order = response.data?.draftOrderComplete.draftOrder?.order else {
            throw NSError(domain: "CODError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Order was not created"])
        }

        return CheckoutOrder(
            id: order.id,
            name: order.name,
            totalPrice: Double(order.totalPriceSet.shopMoney.amount) ?? 0.0,
            paymentStatus: order.displayFinancialStatus,
            createdAt: order.createdAt
        )
    }

    // MARK: - Fetch Latest Order (for Credit Card verification)

    func fetchLatestOrder(customerID: String) async throws -> CheckoutOrder? {
        let query = """
        query getCustomerOrders($id: ID!) {
          customer(id: $id) {
            orders(first: 1, sortKey: CREATED_AT, reverse: true) {
              nodes {
                id
                name
                totalPriceSet { shopMoney { amount } }
                displayFinancialStatus
                createdAt
              }
            }
          }
        }
        """

        struct Vars: Encodable { let id: String }

        let request = GraphQLRequest(query: query, variables: Vars(id: customerID))
        let endpoint = ApiEndpoint(
            path: "/admin/api/2024-04/graphql.json",
            method: .POST,
            headers: ApiEndpoint.adminHeaders
        )

        let response: GraphQLResponse<CustomerOrdersResponse> = try await ApiManager.shared.sendRequest(from: endpoint, with: request)

        guard let node = response.data?.customer?.orders.nodes.first else { return nil }

        return CheckoutOrder(
            id: node.id,
            name: node.name,
            totalPrice: Double(node.totalPriceSet.shopMoney.amount) ?? 0.0,
            paymentStatus: node.displayFinancialStatus,
            createdAt: node.createdAt
        )
    }
}
