//
//  CartView.swift
//  Buyza App
//
//  Created by Antigravity on 30/06/2026.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @StateObject private var viewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var itemToDelete: CartItem? = nil
    @State private var showDeleteAlert = false
    @State private var showClearAlert = false
    @State private var navigateToAddresses = false

    let addressSelectionViewModel :AddressSelectionViewModel
    
    init(viewModel: CartViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        let addressDataSource = ShopifyAddressDataSource()
        let repo = AddressRepositoryImp(remoteDataSource: addressDataSource)
        let getAddressUseCase = GetAddressesUseCase(repository: repo)
        let deleteAdressUseCase = DeleteAddressUseCase(repository: repo)
        addressSelectionViewModel = AddressSelectionViewModel(getAddressesUseCase: getAddressUseCase, deleteAddressUseCase: deleteAdressUseCase)
        
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            if viewModel.isLoading && viewModel.cartItems.isEmpty {
                Spacer()
                ProgressView()
                    .scaleEffect(1.3)
                Spacer()
            } else if viewModel.cartItems.isEmpty && !viewModel.isLoading {
                EmptyCartView(onShopNowTap: { dismiss() })
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.cartItems) { item in
                            CartItemRow(
                                item: item,
                                onIncrement: {
                                    Task {
                                        await viewModel.updateQuantity(
                                            lineID: item.id,
                                            quantity: item.quantity + 1
                                        )
                                    }
                                },
                                onDecrement: {
                                    if item.quantity == 1 {
                                        itemToDelete = item
                                        showDeleteAlert = true
                                    } else {
                                        Task {
                                            await viewModel.updateQuantity(
                                                lineID: item.id,
                                                quantity: item.quantity - 1
                                            )
                                        }
                                    }
                                },
                                onDelete: {
                                    itemToDelete = item
                                    showDeleteAlert = true
                                }
                            )
                            .padding(.horizontal, 20)

                            if item.id != viewModel.cartItems.last?.id {
                                Divider()
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }

                CartSummarySection(
                    subtotal: viewModel.formattedSubtotal,
                    shipping: viewModel.formattedShipping,
                    total: viewModel.formattedTotal,
                    onCheckoutTap: {
                        navigateToAddresses = true
                    }
                )
            }
        }
        .background(Color(.systemBackground))
        .background(
            NavigationLink(
                destination: AddressSelectionView(viewModel: addressSelectionViewModel),
                isActive: $navigateToAddresses
            ) { EmptyView() }
        )
        .navigationBarHidden(true)
        .task { await viewModel.fetchCurrentCart() }
        .alert(localization.text(.removeItem), isPresented: $showDeleteAlert, presenting: itemToDelete) { item in
            Button(localization.text(.cancel), role: .cancel) { }
            Button(localization.text(.remove), role: .destructive) {
                Task { await viewModel.removeItem(lineID: item.id) }
            }
        } message: { item in
            Text(localization.format(.removeItemMessage, item.productTitle))
        }
        .alert(localization.text(.clearCart), isPresented: $showClearAlert) {
            Button(localization.text(.cancel), role: .cancel) { }
            Button(localization.text(.clearAll), role: .destructive) {
                Task { await viewModel.clearCart() }
            }
        } message: {
            Text(localization.text(.clearCartMessage))
        }
    }

    private var navigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text(localization.text(.shoppingCart))
                .font(.headline)
                .fontWeight(.bold)
                .tracking(1)

            Spacer()

            if !viewModel.cartItems.isEmpty {
                Button(action: { showClearAlert = true }) {
                    Text(localization.text(.clear))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                        .frame(height: 44)
                        .padding(.horizontal, 8)
                }
            } else {
                Color.clear
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 4)
    }
}
