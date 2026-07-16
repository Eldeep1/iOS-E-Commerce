//
//  ProductActionBar.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import SwiftUI

struct ProductActionBar: View {
    @EnvironmentObject private var localization: LocalizationManager
    let brandName: String
    let onAddToCart: () -> Void
    let onBuyNow: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: onAddToCart) {
                    Text(localization.text(.addToCart))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

//                Button(action: onBuyNow) {
//                    Text(localization.text(.buyNow))
//                        .font(.headline)
//                        .foregroundColor(.primary)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 16)
//                        .background(Color(.systemGray5))
//                        .clipShape(RoundedRectangle(cornerRadius: 14))
//                }
            }

            Text(localization.format(.secureCheckout, brandName.uppercased()))
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
    }
}
