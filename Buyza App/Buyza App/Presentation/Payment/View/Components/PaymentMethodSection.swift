//
//  PaymentMethodSection.swift
//  Buyza App
//
//  Created by depo on 02/07/2026.
//
import SwiftUI

struct PaymentMethodSection: View {
    @ObservedObject var viewModel: PaymentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Method")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                ForEach(PaymentMethodType.allCases, id: \.self) { method in
                    Button(action: {
                        withAnimation {
                            viewModel.selectedPaymentMethod = method
                        }
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: viewModel.selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                                .font(.system(size: 20))
                                .foregroundColor(viewModel.selectedPaymentMethod == method ? .primary : .secondary.opacity(0.5))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(method.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(viewModel.selectedPaymentMethod == method ? 0.05 : 0.02), radius: 6, x: 0, y: 3)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.selectedPaymentMethod == method ? Color.primary : Color.gray.opacity(0.2), lineWidth: viewModel.selectedPaymentMethod == method ? 2 : 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
