//
//  OrderRowView.swift
//  Buyza App
//

import SwiftUI

struct OrderRowView: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                orderImage

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(order.name)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Spacer()

                        statusBadge
                    }

                    Text(order.formattedDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(itemSummary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }

            Divider()

            HStack {
                Text("\(order.itemCount) item\(order.itemCount == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Text(order.formattedTotal)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }

    private var orderImage: some View {
        Group {
            if let url = order.firstImageURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color(.systemGray5)
                }
            } else {
                ZStack {
                    Color(.systemGray5)
                    Image(systemName: "bag")
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var statusBadge: some View {
        Text(order.statusDisplay)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemGray6))
            .foregroundColor(.primary)
            .cornerRadius(6)
    }

    private var itemSummary: String {
        let titles = order.lineItems.prefix(2).map(\.title)
        guard !titles.isEmpty else { return "No items" }
        let joined = titles.joined(separator: ", ")
        if order.lineItems.count > 2 {
            return "\(joined) +\(order.lineItems.count - 2) more"
        }
        return joined
    }
}

#Preview {
    OrderRowView(
        order: Order(
            id: "1",
            orderNumber: 1001,
            name: "#1001",
            processedAt: Date(),
            financialStatus: "PAID",
            fulfillmentStatus: "FULFILLED",
            totalAmount: 120,
            currencyCode: "USD",
            lineItems: [
                OrderLineItem(
                    id: "1-0",
                    title: "ADIDAS Classic Backpack",
                    quantity: 1,
                    imageURL: nil,
                    totalAmount: 70,
                    currencyCode: "USD"
                )
            ]
        )
    )
    .padding()
}
