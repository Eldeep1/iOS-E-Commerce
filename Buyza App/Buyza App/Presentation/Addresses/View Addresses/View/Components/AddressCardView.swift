//
//  AddressCardView.swift
//  Buyza App
//

import SwiftUI

struct AddressCardView: View {
    @EnvironmentObject private var localization: LocalizationManager
    let address: Address
    let isSelected: Bool
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
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
                            Text(localization.text(.defaultLabel))
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.primary)
                                .foregroundColor(Color(.systemBackground))
                                .cornerRadius(4)
                        }
                        
                        Spacer()
                        
                        // Pencil button is a separate tap target — does NOT conflict with the card's onSelect button
                            Button(action: onEdit) {
                            Image(systemName: "pencil")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                        
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.red)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
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
