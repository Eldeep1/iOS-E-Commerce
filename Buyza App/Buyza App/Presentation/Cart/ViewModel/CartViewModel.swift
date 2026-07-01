//
//  CartViewModel.swift
//  Buyza App
//
//  Created by Antigravity on 30/06/2026.
//

import Foundation
import SwiftUI

@MainActor
class CartViewModel: ObservableObject {
    @Published var cart: CartSummary? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    // Persisted locally so the cart survives app restarts
    @AppStorage("shopify_cart_id") private var storedCartID: String = ""

    private let fetchCartUseCase: FetchCartUseCaseProtocol
    private let addToCartUseCase: AddToCartUseCaseProtocol
    private let removeFromCartUseCase: RemoveFromCartUseCaseProtocol
    private let updateQuantityUseCase: UpdateQuantityUseCaseProtocol

    init(
        fetchCartUseCase: FetchCartUseCaseProtocol,
        addToCartUseCase: AddToCartUseCaseProtocol,
        removeFromCartUseCase: RemoveFromCartUseCaseProtocol,
        updateQuantityUseCase: UpdateQuantityUseCaseProtocol
    ) {
        self.fetchCartUseCase = fetchCartUseCase
        self.addToCartUseCase = addToCartUseCase
        self.removeFromCartUseCase = removeFromCartUseCase
        self.updateQuantityUseCase = updateQuantityUseCase
    }

    // MARK: - Computed Display Properties

    var cartItems: [CartItem] {
        cart?.items ?? []
    }

    var formattedSubtotal: String {
        format(cart?.subtotal ?? 0, currency: cart?.currencyCode ?? "USD")
    }

    var formattedShipping: String {
        return "Calculated at checkout"
    }

    var formattedTotal: String {
        return format(cart?.total ?? 0, currency: cart?.currencyCode ?? "USD")
    }

    // MARK: - Actions

    func addToCart(variantID: String, quantity: Int = 1) async {
        isLoading = true
        do {
            let result = try await addToCartUseCase.execute(
                cartID: storedCartID.isEmpty ? nil : storedCartID,
                variantID: variantID,
                quantity: quantity
            )
            cart = result
            storedCartID = result.cartID
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func removeItem(lineID: String) async {
        guard !storedCartID.isEmpty else { return }
        isLoading = true
        do {
            cart = try await removeFromCartUseCase.execute(cartID: storedCartID, lineID: lineID)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func updateQuantity(lineID: String, quantity: Int) async {
        guard !storedCartID.isEmpty else { return }
        isLoading = true
        do {
            cart = try await updateQuantityUseCase.execute(cartID: storedCartID, lineID: lineID, quantity: quantity)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func fetchCurrentCart() async {
        guard !storedCartID.isEmpty else { return }
        isLoading = true
        do {
            cart = try await fetchCartUseCase.execute(cartID: storedCartID)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func clearCart() async {
        guard !storedCartID.isEmpty else { return }
        isLoading = true
        // Remove all lines concurrently
        await withTaskGroup(of: Void.self) { group in
            for item in cartItems {
                group.addTask { [weak self] in
                    guard let self else { return }
                    _ = try? await self.removeFromCartUseCase.execute(
                        cartID: self.storedCartID,
                        lineID: item.id
                    )
                }
            }
        }
        cart = nil
        storedCartID = ""
        isLoading = false
    }

    // MARK: - Helpers

    private func format(_ amount: Decimal, currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }
}
