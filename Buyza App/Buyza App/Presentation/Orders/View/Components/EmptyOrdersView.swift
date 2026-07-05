//
//  EmptyOrdersView.swift
//  Buyza App
//

import SwiftUI

struct EmptyOrdersView: View {
    @EnvironmentObject private var localization: LocalizationManager
    var message: String?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "shippingbox")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text(localization.text(.noOrders))
                .font(.title3)
                .fontWeight(.semibold)

            Text(message ?? localization.text(.noOrdersSubtitle))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyOrdersView()
        .environmentObject(LocalizationManager())
}
