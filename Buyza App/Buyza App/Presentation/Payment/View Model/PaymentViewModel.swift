//
//  PaymentViewModel.swift
//  Buyza App
//
//  Created by depo on 02/07/2026.
//

import Foundation

enum PaymentMethodType: String, CaseIterable {
    case creditCard = "Credit / Debit Card"
    case cashOnDelivery = "Cash on Delivery"
}

class PaymentViewModel: ObservableObject {
    @Published var selectedPaymentMethod: PaymentMethodType = .creditCard
    @Published var couponCode: String = ""
    @Published var isApplyingCoupon: Bool = false
    @Published var isPlacingOrder: Bool = false
    @Published var couponError: String? = nil
    @Published var isLoading: Bool = false
    @Published var orderError: String? = nil

    // Domain Data
    @Published var subtotal: Double = 0.0
    @Published var shippingCost: Double = 0.0
    @Published var discountAmount: Double = 0.0
    @Published var total: Double = 0.0

    @Published var deliveryAddressString: String = ""
    @Published var webUrl: URL? = nil

    
    @Published var showWebView: Bool = false
    @Published var navigateToSuccess: Bool = false
    @Published var navigateToPending: Bool = false
    @Published var placedOrder: Order? = nil
    
    private var checkoutStartedAt: Date? = nil

    private var cartID: String {
        get { UserDefaults.standard.string(forKey: "shopify_cart_id") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "shopify_cart_id") }
    }
    private let address: Address
    private let customerID: String
    private let createCheckoutUseCase: CreateCheckoutUseCase
    private let applyDiscountUseCase: ApplyDiscountUseCase
    private let placeCODOrderUseCase: PlaceCODOrderUseCase
    private let fetchLatestOrderUseCase: FetchLatestOrderUseCase

    init(
        address: Address,
        customerID: String,
        createCheckoutUseCase: CreateCheckoutUseCase,
        applyDiscountUseCase: ApplyDiscountUseCase,
        placeCODOrderUseCase: PlaceCODOrderUseCase,
        fetchLatestOrderUseCase: FetchLatestOrderUseCase
    ) {
        self.address = address
        self.customerID = customerID
        self.createCheckoutUseCase = createCheckoutUseCase
        self.applyDiscountUseCase = applyDiscountUseCase
        self.placeCODOrderUseCase = placeCODOrderUseCase
        self.fetchLatestOrderUseCase = fetchLatestOrderUseCase
        self.deliveryAddressString = address.fullAddressString
    }

    // MARK: - Load Checkout

    @MainActor
    func loadCheckout() async {
        isLoading = true
        do {
            let summary = try await createCheckoutUseCase.execute(cartID: cartID, addressID: address.id)
            self.cartID = summary.id
            updateSummary(summary)
            
            if summary.discount > 0 && couponCode.isEmpty {
                await clearDiscount()
            }
        } catch {
            print("Error loading checkout: \(error)")
        }
        isLoading = false
    }
    // MARK: - Clear Discount
    
    @MainActor
    func clearDiscount() async {
        if discountAmount > 0 {
            if let clearedSummary = try? await applyDiscountUseCase.execute(checkoutID: cartID, discountCode: "") {
                self.cartID = clearedSummary.id
                updateSummary(clearedSummary)
            }
        }
    }

    // MARK: - Apply Coupon

    @MainActor
    func applyCoupon() async {
        guard !couponCode.isEmpty else { return }

        isApplyingCoupon = true
        couponError = nil

        do {
            let summary = try await applyDiscountUseCase.execute(checkoutID: cartID, discountCode: couponCode)
            if summary.discount <= 0 {
                // Remove the coupon if it was invalid
                if let clearedSummary = try? await applyDiscountUseCase.execute(checkoutID: cartID, discountCode: "") {
                    self.cartID = clearedSummary.id
                    updateSummary(clearedSummary)
                }
                couponError = "Invalid coupon code"
                isApplyingCoupon = false
                return
            }
            self.cartID = summary.id
            updateSummary(summary)
            couponError = nil
        } catch {
            // Remove the coupon if it was invalid
            if let clearedSummary = try? await applyDiscountUseCase.execute(checkoutID: cartID, discountCode: "") {
                self.cartID = clearedSummary.id
                updateSummary(clearedSummary)
            }
            couponError = "Invalid coupon code"
        }

        isApplyingCoupon = false
    }

    // MARK: - Place Order

    @MainActor
    func placeOrder() {
        orderError = nil
        switch selectedPaymentMethod {
        case .cashOnDelivery:
            Task { await placeCOD() }
        case .creditCard:
            guard webUrl != nil else {
                orderError = "Checkout URL is not ready yet."
                return
            }
            checkoutStartedAt = Date()
            showWebView = true
        }
    }

    @MainActor
    private func placeCOD() async {
        isPlacingOrder = true
        do {
            let order = try await placeCODOrderUseCase.execute(
                cartID: cartID,
                address: address,
                customerID: customerID,
                discountAmount: discountAmount,
                discountCode: couponCode.isEmpty ? nil : couponCode
            )
            placedOrder = order
            navigateToPending = true
        } catch {
            orderError = "Failed to place order. Please try again."
            print("COD Error: \(error)")
        }
        isPlacingOrder = false
    }

    // MARK: - Called when user returns from Webview

    @MainActor
    func checkOrderAfterWebReturn() async {
        // if user dismissed without paying, check if an order was placed
        isPlacingOrder = true
        orderError = nil

        // give Shopify 2 seconds to process the order before polling
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        do {
            if let order = try await fetchLatestOrderUseCase.execute(customerID: customerID) {
                // transfr the order's createdAt string into a Date
                let formatter = ISO8601DateFormatter()
                
                formatter.formatOptions = [.withInternetDateTime]
                var orderDate = formatter.date(from: order.createdAt)
                if orderDate == nil {
                    // Try with fractional seconds
                    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    orderDate = formatter.date(from: order.createdAt)
                }

                let startedAt = checkoutStartedAt ?? Date.distantPast
                
                // Add a small buffer (e.g., 60 seconds) in case of device clock sync issues
                let isNewOrder = (orderDate ?? Date.distantPast) > startedAt.addingTimeInterval(-60)
                
                if isNewOrder {
                    if order.paymentStatus.lowercased() == "paid" {
                        placedOrder = order
                        navigateToSuccess = true
                    } else {
                        
                        orderError = "Payment was not completed. Please try again."
                    }
                } else {
                    // that's an old order, the user just closed the browser
                    orderError = "Payment was cancelled."
                }
            } else {
                // No order found — user closed the browser without paying
                orderError = "Payment was cancelled."
            }
        } catch {
            orderError = "Could not verify payment. Please contact support."
            print("Order check error: \(error)")
        }

        isPlacingOrder = false
    }

   

    private func updateSummary(_ summary: CheckoutSummary) {
        self.subtotal = summary.subtotal
        self.shippingCost = summary.shipping
        self.discountAmount = summary.discount
        self.total = summary.total
        self.webUrl = summary.webUrl
    }
}
