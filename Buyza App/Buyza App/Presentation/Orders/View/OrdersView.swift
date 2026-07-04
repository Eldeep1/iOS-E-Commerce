//
//  OrdersView.swift
//  Buyza App
//

import SwiftUI

struct OrdersView: View {
    @StateObject private var viewModel: OrdersViewModel

    init(viewModel: OrdersViewModel = OrdersViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage, viewModel.orders.isEmpty {
                    EmptyOrdersView(message: errorMessage)
                } else if viewModel.orders.isEmpty {
                    EmptyOrdersView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.orders) { order in
                                OrderRowView(order: order)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Orders")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                if viewModel.orders.isEmpty && viewModel.errorMessage == nil {
                    viewModel.loadOrders()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.loadOrders()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    OrdersView()
}
