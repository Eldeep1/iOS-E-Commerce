//
//  OrderSuccessView.swift
//  Buyza App
//

import SwiftUI

extension Notification.Name {
    static let popToRoot = Notification.Name("popToRoot")
}

struct OrderSuccessView: View {
    let order: Order?

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 120, height: 120)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 72))
                    .foregroundColor(.green)
            }
            .padding(.bottom, 32)

            // Title
            Text("Payment Successful!")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)

            Text("Your order has been confirmed and is being prepared.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)

            // Order Details Card
            if let order {
                VStack(spacing: 12) {
                    orderRow(label: "Order Number", value: order.name)
                    Divider()
                    orderRow(label: "Total Paid", value: String(format: "$%.2f", order.totalPrice))
                    Divider()
                    orderRow(label: "Payment Status", value: order.paymentStatus.capitalized)
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
