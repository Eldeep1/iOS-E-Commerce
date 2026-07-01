//
//  AddressCardView.swift
//  Buyza App
//

import SwiftUI

struct AddressCardView: View {
    let address: AddressUIModel
    let isSelected: Bool
    let onSelect: () -> Void
    var onEdit: (() -> Void)? = nil
    
    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: 16) {
                // Radio Button
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .primary : .secondary.opacity(0.5))
                    .padding(.top, 4)
                
                // Address Details
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(address.fullName)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        if address.isDefault {
                            Text("Default")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.primary)
                                .foregroundColor(Color(.systemBackground))
                                .cornerRadius(4)
                        }
                        
                        Spacer()
                        
                        if let onEdit = onEdit {
                            Button(action: onEdit) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Text(address.phoneNumber)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(address.fullAddressString)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.primary : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        AddressCardView(address: AddressUIModel.mocks[0], isSelected: true, onSelect: {}, onEdit: {})
        AddressCardView(address: AddressUIModel.mocks[1], isSelected: false, onSelect: {}, onEdit: {})
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
