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
    
    // Domain Data
    @Published var subtotal: Double = 0.0
    @Published var shippingCost: Double = 0.0
    @Published var discountAmount: Double = 0.0
    @Published var total: Double = 0.0
    
    @Published var deliveryAddressString: String = "123 Apple Park Way, Cupertino, CA 95014"
    @Published var webUrl: URL? = nil
    
    private let cartID: String
    private let addressID: String?
    private let createCheckoutUseCase: CreateCheckoutUseCase
    private let applyDiscountUseCase: ApplyDiscountUseCase
    
    init(
        cartID: String,
        addressID: String? = nil,
        createCheckoutUseCase: CreateCheckoutUseCase,
        applyDiscountUseCase: ApplyDiscountUseCase
    ) {
        self.cartID = cartID
        self.addressID = addressID
        self.createCheckoutUseCase = createCheckoutUseCase
        self.applyDiscountUseCase = applyDiscountUseCase
    }
    
    @MainActor
    func loadCheckout() async {
        isLoading = true
        do {
            let summary = try await createCheckoutUseCase.execute(cartID: cartID, addressID: addressID)
            updateSummary(summary)
        } catch {
            print("Error loading checkout: \(error)")
        }
        isLoading = false
    }
    
    @MainActor
    func applyCoupon() async {
        guard !couponCode.isEmpty else { return }
        
        isApplyingCoupon = true
        couponError = nil
        
        do {
            let summary = try await applyDiscountUseCase.execute(checkoutID: cartID, discountCode: couponCode)
            updateSummary(summary)
            couponError = nil
        } catch {
            couponError = "Invalid coupon code"
            print("Error applying coupon: \(error)")
        }
        
        isApplyingCoupon = false
    }
    
    private func updateSummary(_ summary: CheckoutSummary) {
        self.subtotal = summary.subtotal
        self.shippingCost = summary.shipping
        self.discountAmount = summary.discount
        self.total = summary.total
        self.webUrl = summary.webUrl
    }
    
    func placeOrder() {
        // Since we are using the webUrl for both Credit Card and COD:
        guard let url = webUrl else { return }
        print("Opening Web Checkout: \(url.absoluteString)")
        // In a real app, you would use a coordinator or navigation state to open SFSafariViewController with this URL
    }
}
