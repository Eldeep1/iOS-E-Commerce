//
//  ProductDetailView.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var viewModel: ProductDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(product: Product, useCase: ProductDetailUseCaseProtocol = ProductDetailUseCase()) {
        _viewModel = StateObject(
            wrappedValue: ProductDetailViewModel(product: product, useCase: useCase)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ProductImageCarousel(
                        imageURLs: viewModel.product.imageURLs,
                        currentIndex: $viewModel.currentImageIndex,
                        isFavorite: viewModel.isFavorite,
                        onFavoriteTap: viewModel.toggleFavorite
                    )

                    productInfoSection
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 120)
                }
            }

            ProductActionBar(
                brandName: viewModel.product.brandName,
                onAddToCart: viewModel.addToCart,
                onBuyNow: viewModel.buyNow
            )
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
        .background(
            NavigationLink(destination: makeCartView(), isActive: $viewModel.navigateToCart) {
                EmptyView()
            }
        )
        .overlay {
            if viewModel.isAddToCartLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                }
            }
        }
        .alert("Added to Cart", isPresented: $viewModel.addToCartSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(viewModel.product.title) was added to your cart.")
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.addToCartError != nil },
            set: { if !$0 { viewModel.addToCartError = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.addToCartError ?? "")
        }
        .alert("Sign In Required", isPresented: $viewModel.showGuestAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign In") {
                appState.isGuest = false
                appState.currentRoute = .auth
            }
        } message: {
            Text("Please sign in to enjoy adding products to your favorites and cart. It only takes a moment!")
        }
        .onAppear {
            viewModel.isGuest = appState.isGuest
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

            Text(viewModel.product.brandName)
                .font(.headline)
                .fontWeight(.bold)
                .tracking(2)

            Spacer()

            Button(action: {
                if viewModel.isGuest {
                    viewModel.showGuestAlert = true
                } else {
                    viewModel.navigateToCart = true
                }
            }) {
                Image(systemName: "bag")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 4)
    }

    private var productInfoSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Text(viewModel.product.title)
                        .font(.system(size: 34, weight: .bold))

                    Spacer()

                    Text(viewModel.formattedPrice)
                        .font(.system(size: 28, weight: .bold))
                }

                Text(viewModel.product.product_type)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

            if viewModel.showsSizeSelector {
                ProductSizeSelector(
                    sizes: viewModel.product.sizeValues,
                    selectedIndex: viewModel.selectedSizeIndex,
                    onSelect: viewModel.selectSize(at:)
                )
            }

            if viewModel.showsColorSelector {
                ProductColorSelector(
                    colors: viewModel.product.colorValues,
                    selectedIndex: viewModel.selectedColorIndex,
                    selectedColorLabel: viewModel.selectedColorLabel,
                    onSelect: viewModel.selectColor(at:)
                )
            }

            VStack(spacing: 0) {
                ForEach(viewModel.informationSections) { section in
                    ProductAccordionSection(
                        section: section,
                        isExpanded: viewModel.expandedSectionIDs.contains(section.id),
                        onToggle: { viewModel.toggleSection(section.id) }
                    )
                }
            }
        }
    }
    
    private func makeCartView() -> some View {
        let repo = CartRepositoryImp()
        let fetchCartUseCase = FetchCartUseCase(repository: repo)
        let addToCartUseCase = AddToCartUseCase(repository: repo)
        let removeFromCartUseCase = RemoveFromCartUseCase(repository: repo)
        let updateQuantityUseCase = UpdateQuantityUseCase(repository: repo)
        let cartViewModel = CartViewModel(
            fetchCartUseCase: fetchCartUseCase,
            addToCartUseCase: addToCartUseCase,
            removeFromCartUseCase: removeFromCartUseCase,
            updateQuantityUseCase: updateQuantityUseCase
        )
        return CartView(viewModel: cartViewModel)
    }
}

#Preview {
    NavigationView {
        ProductDetailView(product: .adidasClassicBackpack)
    }
}
