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
    
    // Mock Data for now
    @Published var subtotal: Double = 120.50
    @Published var shippingCost: Double = 15.00
    @Published var discountAmount: Double = 0.00
    
    @Published var deliveryAddressString: String = "123 Apple Park Way, Cupertino, CA 95014"
    
    var total: Double {
        return max(0, (subtotal + shippingCost) - discountAmount)
    }
    
    func applyCoupon() {
        guard !couponCode.isEmpty else { return }
        
        isApplyingCoupon = true
        couponError = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isApplyingCoupon = false
            
            if self?.couponCode.lowercased() == "buyza10" {
                self?.discountAmount = 10.0
                self?.couponError = nil
            } else {
                self?.discountAmount = 0.0
                self?.couponError = "Invalid coupon code"
            }
        }
    }
    
    func placeOrder() {
        isPlacingOrder = true
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.isPlacingOrder = false
            print("Order Placed via \(self?.selectedPaymentMethod.rawValue ?? "")")
        }
    }
}
