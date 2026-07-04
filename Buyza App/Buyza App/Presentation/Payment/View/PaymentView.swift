//
//  PaymentView.swift
//  Buyza App
//
//  Created by depo on 02/07/2026.
//

import SwiftUI

struct PaymentView: View {
    @StateObject var viewModel: PaymentViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            // making error message always visible
            if let error = viewModel.orderError {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red.opacity(0.08))
                )
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }

            ScrollView {
                VStack(spacing: 24) {
                    PaymentAddressSection(viewModel: viewModel, onChangeTap: {
                        dismiss()
                    })
                    CouponSection(viewModel: viewModel)
                    OrderSummarySection(viewModel: viewModel)
                    PaymentMethodSection(viewModel: viewModel)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 30)
            }

            placeOrderFooter
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            await viewModel.loadCheckout()
        }
        // Hidden NavigationLinks
        .background(
            Group {
                NavigationLink(
                    destination: OrderSuccessView(order: viewModel.placedOrder),
                    isActive: $viewModel.navigateToSuccess
                ) { EmptyView() }

                NavigationLink(
                    destination: OrderPendingView(order: viewModel.placedOrder),
                    isActive: $viewModel.navigateToPending
                ) { EmptyView() }
            }
        )
        // Safari sheet for Credit Card
        .fullScreenCover(isPresented: $viewModel.showWebView, onDismiss: {
            Task { await viewModel.checkOrderAfterWebReturn() }
        }) {
            if let url = viewModel.webUrl {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
        .onDisappear {
            let vm = viewModel
            if !vm.navigateToSuccess && !vm.navigateToPending && !vm.showWebView && !vm.isPlacingOrder {
                Task {
                    await vm.clearDiscount()
                }
            }
        }
    }

    // MARK: - Navigation Bar

    private var navigationBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text("Checkout")
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

    // MARK: - Footer

    private var placeOrderFooter: some View {
        VStack {
            Button(action: {
                viewModel.placeOrder()
            }) {
                HStack {
                    if viewModel.isPlacingOrder {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Place Order")
                            .font(.headline)
                        Spacer()
                        Text("$\(String(format: "%.2f", viewModel.total))")
                            .font(.headline)
                    }
                }
                .foregroundColor(Color(.systemBackground))
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.primary)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .disabled(viewModel.isPlacingOrder || viewModel.isLoading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
        )
    }
}
