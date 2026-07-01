//
//  CartItemRow.swift
//  Buyza App
//
//  Created by Antigravity on 30/06/2026.
//

import SwiftUI

struct CartItemRow: View {
    let item: CartItem
    var onIncrement: () -> Void
    var onDecrement: () -> Void
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            // Product Image
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    placeholderImage
                @unknown default:
                    placeholderImage
                }
            }
            .frame(width: 90, height: 110)
            .cornerRadius(12)
            .clipped()

            // Product Details
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.brandName)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(1.5)

                        Text(item.productTitle)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                    }

                    Spacer()

                    // Delete Button
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(.systemGray2))
                            .frame(width: 32, height: 32)
                    }
                }

                Spacer(minLength: 0)

                // Price & Quantity Selector
                HStack {
                    Text(format(item.unitPrice, currency: item.currencyCode))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)

                    Spacer()

                    // Quantity Counter Pill
                    HStack(spacing: 0) {
                        Button(action: onDecrement) {
                            Image(systemName: item.quantity > 1 ? "minus" : "trash")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.primary)
                                .frame(width: 32, height: 32)
                        }

                        Text("\(item.quantity)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .frame(width: 28)
                            .multilineTextAlignment(.center)

                        Button(action: onIncrement) {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.primary)
                                .frame(width: 32, height: 32)
                        }
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
            }
        }
        .padding(.vertical, 12)
    }

    private var placeholderImage: some View {
        ZStack {
            Color(.systemGray5)
            Image(systemName: "photo")
                .foregroundColor(.secondary)
        }
    }

    private func format(_ amount: Decimal, currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }
}

#Preview {
    CartItemRow(
        item: CartItem(
            id: "line_1",
            variantID: "variant_1",
            productTitle: "ADIDAS | CLASSIC BACKPACK",
            brandName: "ADIDAS",
            imageURL: URL(string: "https://cdn.shopify.com/s/files/1/0790/8907/4373/files/product_29_image1.jpg"),
            unitPrice: 70.00,
            currencyCode: "USD",
            quantity: 1
        ),
        onIncrement: {},
        onDecrement: {},
        onDelete: {}
    )
    .padding()
    .previewLayout(.sizeThatFits)
}
