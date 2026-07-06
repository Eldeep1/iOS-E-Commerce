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
    @Published var placedOrder: CheckoutOrder? = nil
    
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
    private let placePaidOrderUseCase: PlacePaidOrderUseCase
    private let fetchLatestOrderUseCase: FetchLatestOrderUseCase

    init(
        address: Address,
        customerID: String,
        createCheckoutUseCase: CreateCheckoutUseCase,
        applyDiscountUseCase: ApplyDiscountUseCase,
        placeCODOrderUseCase: PlaceCODOrderUseCase,
        placePaidOrderUseCase: PlacePaidOrderUseCase,
        fetchLatestOrderUseCase: FetchLatestOrderUseCase
    ) {
        self.address = address
        self.customerID = customerID
        self.createCheckoutUseCase = createCheckoutUseCase
        self.applyDiscountUseCase = applyDiscountUseCase
        self.placeCODOrderUseCase = placeCODOrderUseCase
        self.placePaidOrderUseCase = placePaidOrderUseCase
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
                couponError = L10n.invalidCouponCode.text(for: AppLanguage.stored)
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
            couponError = L10n.invalidCouponCode.text(for: AppLanguage.stored)
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
            Task { await preparePaymobCheckout() }
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
            orderError = L10n.failedPlaceOrder.text(for: AppLanguage.stored)
            print("COD Error: \(error)")
        }
        isPlacingOrder = false
    }

    @MainActor
    private func preparePaymobCheckout() async {
        isPlacingOrder = true
        do {
            let paymobURL = try await PaymobService.shared.generatePaymentURL(
                amount: total,
                address: address
            )
            self.webUrl = paymobURL
            self.showWebView = true
        } catch {
            orderError = "Could not initialize credit card checkout. Please try again."
            print("Paymob Error: \(error)")
        }
        isPlacingOrder = false
    }

    @MainActor
    func handlePaymobResult(success: Bool) async {
        showWebView = false
        
        guard success else {
            orderError = "Payment was declined or cancelled. Please try again."
            isPlacingOrder = false
            return
        }
        
        isPlacingOrder = true
        orderError = nil

        do {
            let order = try await placePaidOrderUseCase.execute(
                cartID: cartID,
                address: address,
                customerID: customerID,
                discountAmount: discountAmount,
                discountCode: couponCode.isEmpty ? nil : couponCode
            )
            placedOrder = order
            navigateToSuccess = true
        } catch {
            orderError = "Payment confirmation failed. If your card was charged, please contact support."
            print("Paid Order Error: \(error)")
        }

        isPlacingOrder = false
    }
    
    @MainActor
    func handlePaymobCancel() {
        if isPlacingOrder { return }
        orderError = "Payment was cancelled."
    }

   

    private func updateSummary(_ summary: CheckoutSummary) {
        self.subtotal = summary.subtotal
        self.shippingCost = summary.shipping
        self.discountAmount = summary.discount
        self.total = summary.total
        self.webUrl = summary.webUrl
    }
}
