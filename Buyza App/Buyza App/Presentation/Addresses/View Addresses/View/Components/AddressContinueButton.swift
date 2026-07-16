//
//  AddressContinueButton.swift
//  Buyza App
//

import SwiftUI

struct AddressContinueButton: View {
    @EnvironmentObject private var localization: LocalizationManager
    let selectedAddressId: String?
    let onContinue: () -> Void
    
    var body: some View {
        VStack {
            Button(action: onContinue) {
                Text(localization.text(.continueToPayment))
                    .font(.headline)
                    .foregroundColor(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(selectedAddressId == nil ? Color.gray : Color.primary)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(selectedAddressId == nil ? 0 : 0.05), radius: 8, x: 0, y: 4)
            }
            .disabled(selectedAddressId == nil)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
        )
    }
}
