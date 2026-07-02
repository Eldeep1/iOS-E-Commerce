//
//  CouponSection.swift
//  Buyza App
//
//  Created by depo on 02/07/2026.
//
import SwiftUI

struct CouponSection: View {
    @ObservedObject var viewModel: PaymentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Promo Code")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    TextField("Enter promo code", text: $viewModel.couponCode)
                        .padding(14)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                    
                    Button(action: {
                        viewModel.applyCoupon()
                    }) {
                        if viewModel.isApplyingCoupon {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Apply")
                                .fontWeight(.bold)
                        }
                    }
                    .frame(width: 80, height: 48)
                    .background(Color.primary)
                    .foregroundColor(Color(.systemBackground))
                    .cornerRadius(10)
                    .disabled(viewModel.couponCode.isEmpty || viewModel.isApplyingCoupon)
                }
                
                if let error = viewModel.couponError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                } else if viewModel.discountAmount > 0 {
                    Text("Coupon applied successfully!")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
    }
}
