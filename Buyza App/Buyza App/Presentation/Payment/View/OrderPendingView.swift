//
//  OrderPendingView.swift
//  Buyza App
//

import SwiftUI

struct OrderPendingView: View {
    let order: Order?

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.12))
                    .frame(width: 120, height: 120)
                Image(systemName: "clock.fill")
                    .font(.system(size: 72))
                    .foregroundColor(.orange)
            }
            .padding(.bottom, 32)

            // Title
            Text("Order Placed!")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)

            Text("Your order has been received. Please pay the courier upon delivery.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)

            // COD Instruction Banner
            HStack(spacing: 12) {
                Image(systemName: "banknote")
                    .font(.system(size: 22))
                    .foregroundColor(.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Cash on Delivery")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("Have exact change ready for the courier.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.08))
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            // Order Details Card
            if let order {
                VStack(spacing: 12) {
                    orderRow(label: "Order Number", value: order.name)
                    Divider()
                    orderRow(label: "Total Amount", value: String(format: "$%.2f", order.totalPrice))
                    Divider()
                    orderRow(label: "Payment", value: "Cash on Delivery")
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }

            Spacer()

            // CTA
            Button(action: {
                NotificationCenter.default.post(name: .popToRoot, object: nil)
            }) {
                Text("Continue Shopping")
                    .font(.headline)
                    .foregroundColor(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.primary)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            UserDefaults.standard.set("", forKey: "shopify_cart_id")
        }
    }

    private func orderRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}
