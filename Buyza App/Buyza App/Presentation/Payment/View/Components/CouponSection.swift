//
//  CouponSection.swift
//  Buyza App
//
//  Created by depo on 02/07/2026.
//
import SwiftUI

struct CouponSection: View {
    @EnvironmentObject private var localization: LocalizationManager
    @ObservedObject var viewModel: PaymentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(localization.text(.promoCode))
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    TextField(localization.text(.promoCode), text: $viewModel.couponCode)
                        .padding(14)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                    
                    Button(action: {
                        Task {
                            await viewModel.applyCoupon()
                        }
                    }) {
                        if viewModel.isApplyingCoupon {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color(.systemBackground)))
                        } else {
                            Text(localization.text(.apply))
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
                    Text(localization.text(.couponApplied))
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
    }
}
