//
//  CartSummarySection.swift
//  Buyza App
//
//  Created by Antigravity on 30/06/2026.
//

import SwiftUI

struct CartSummarySection: View {
    let subtotal: String
    let shipping: String
    let total: String
    var onCheckoutTap: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                // Subtotal
                HStack {
                    Text("Subtotal")
                        .font(.body)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(subtotal)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                // Shipping
                HStack {
                    Text("Shipping")
                        .font(.body)
                        .foregroundColor(.secondary)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 12))
                        Text(shipping)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.secondary)
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                // Total
                HStack {
                    Text("Total")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(total)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            // Checkout button
            Button(action: onCheckoutTap) {
                HStack {
                    Text("Proceed to Payment")
                        .font(.headline)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(Color(.systemBackground))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.primary)
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            .padding(.bottom, 24)
        }
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
        )
    }
}

#Preview {
    CartSummarySection(
        subtotal: "$70.00",
        shipping: "$15.00",
        total: "$85.00"
    )
    .previewLayout(.sizeThatFits)
}
