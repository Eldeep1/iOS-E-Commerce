//
//  AddressInputField.swift
//  Buyza App
//

import SwiftUI

struct AddressInputField: View {
    let label: String
    let placeholder: String
    let icon: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var errorMessage: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label
            Text(label.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.gray)
                .tracking(1)

            // Input Row
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(text.isEmpty ? .gray.opacity(0.5) : .primary)
                    .frame(width: 20)

                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled()
            }
            .padding(14)
            .background(Color(.systemGray6).opacity(0.6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        errorMessage != nil ? Color.red.opacity(0.6) : Color.clear,
                        lineWidth: 1
                    )
            )

            // Inline error
            if let error = errorMessage {
                Text(error)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.red)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
