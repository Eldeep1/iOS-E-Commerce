//
//  OrderSummarySection.swift
//  Buyza App
//
//  Created by depo on 02/07/2026.
//

import SwiftUI

struct OrderSummarySection: View {
    @ObservedObject var viewModel: PaymentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Summary")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                summaryRow(title: "Subtotal", amount: viewModel.subtotal)
                summaryRow(title: "Shipping", amount: viewModel.shippingCost)
                
                if viewModel.discountAmount > 0 {
                    summaryRow(title: "Discount", amount: -viewModel.discountAmount, isDiscount: true)
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                HStack {
                    Text("Total")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("$\(String(format: "%.2f", viewModel.total))")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
    }
    
    private func summaryRow(title: String, amount: Double, isDiscount: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("\(isDiscount ? "" : "$" )\(String(format: "%.2f", amount))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isDiscount ? .green : .primary)
        }
    }
}
