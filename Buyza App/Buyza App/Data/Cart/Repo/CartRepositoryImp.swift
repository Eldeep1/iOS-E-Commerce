//
//  CartRepositoryImp.swift
//  Buyza App
//
//  Created by depo on 30/06/2026.
//

import Foundation

struct CartRepositoryImp: CartRepositoryProtocol {

    private let remoteDataSource: CartDataSourceProtocol

    init(remoteDataSource: CartDataSourceProtocol = ShopifyCartDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func createCart(variantID: String, quantity: Int) async throws -> CartSummary {
        let response = try await remoteDataSource.createCart(variantID: variantID, quantity: quantity)
        return map(response)
    }

    func fetchCart(cartID: String) async throws -> CartSummary {
        let response = try await remoteDataSource.fetchCart(cartID: cartID)
        return map(response)
    }

    func addLines(cartID: String, variantID: String, quantity: Int) async throws -> CartSummary {
        let response = try await remoteDataSource.addLines(cartID: cartID, variantID: variantID, quantity: quantity)
        return map(response)
    }

    func updateLine(cartID: String, lineID: String, quantity: Int) async throws -> CartSummary {
        let response = try await remoteDataSource.updateLine(cartID: cartID, lineID: lineID, quantity: quantity)
        return map(response)
    }

    func removeLine(cartID: String, lineID: String) async throws -> CartSummary {
        let response = try await remoteDataSource.removeLine(cartID: cartID, lineID: lineID)
        return map(response)
    }

    // MARK: - Data → Domain Mapping

    private func map(_ response: Cart) -> CartSummary {
        CartSummary(
            cartID: response.id,
            items: response.lines.edges.map { edge in
                let node = edge.node
                return CartItem(
                    id: node.id,
                    variantID: node.merchandise.id,
                    productTitle: node.merchandise.product.title,
                    brandName: node.merchandise.product.vendor,
                    imageURL: URL(string: node.merchandise.product.featuredImage?.url ?? ""),
                    unitPrice: Decimal(string: node.cost.totalAmount.amount) ?? 0,
                    currencyCode: node.cost.totalAmount.currencyCode,
                    quantity: node.quantity
                )
            },
            subtotal: Decimal(string: response.cost.subtotalAmount.amount) ?? 0,
            total: Decimal(string: response.cost.totalAmount.amount) ?? 0,
            currencyCode: response.cost.totalAmount.currencyCode
        )
    }
}
