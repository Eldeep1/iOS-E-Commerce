//
//  PaymentAddressSection.swift
//  Buyza App
//
//  Created by depo on 02/07/2026.
//
import SwiftUI

struct PaymentAddressSection: View {
    @ObservedObject var viewModel: PaymentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Delivery Address")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    // This will navigate back or push an address selection view later
                }) {
                    Text("Change")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
            }
            
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.primary)
                
                Text(viewModel.deliveryAddressString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
            )
        }
    }
}
