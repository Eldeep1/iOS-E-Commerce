//
//  AddressNavigationBar.swift
//  Buyza App
//

import SwiftUI

struct AddressNavigationBar: View {
    @EnvironmentObject private var localization: LocalizationManager
    var onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onDismiss) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text(localization.text(.selectAddress))
                .font(.headline)
                .fontWeight(.bold)
                .tracking(1)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 8)
        .padding(.top, 4)
        .background(Color(.systemBackground))
    }
}
