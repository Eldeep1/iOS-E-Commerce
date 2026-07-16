//
//  OrderSuccessView.swift
//  Buyza App
//

import SwiftUI

extension Notification.Name {
    static let popToRoot = Notification.Name("popToRoot")
}

struct OrderSuccessView: View {
    @EnvironmentObject private var localization: LocalizationManager
    let order: CheckoutOrder?

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 120, height: 120)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 72))
                    .foregroundColor(.green)
            }
            .padding(.bottom, 32)

            Text(localization.text(.paymentSuccessful))
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)

            Text(localization.text(.orderConfirmed))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)

            if let order {
                VStack(spacing: 12) {
                    orderRow(label: localization.text(.orderNumber), value: order.name)
                    Divider()
                    orderRow(label: localization.text(.total), value: String(format: "$%.2f", order.totalPrice))
                    Divider()
                    orderRow(label: localization.text(.paymentMethod), value: order.paymentStatus.capitalized)
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

            Button(action: {
                NotificationCenter.default.post(name: .popToRoot, object: nil)
            }) {
                Text(localization.text(.continueShopping))
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
