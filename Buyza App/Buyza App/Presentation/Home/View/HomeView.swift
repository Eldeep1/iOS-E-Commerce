//
//  HomeView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject private var localization: LocalizationManager
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HomeHeader()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        EventsList()

                        VStack(alignment: .leading, spacing: 16) {
                            Text(localization.text(.categories))
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)

                            if viewModel.isCategoriesLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            } else {
                                CategoriesListView(viewModel: viewModel)
                            }
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            Text(localization.text(.brands))
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)

                            if viewModel.isBrandsLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            } else {
                                BrandsListView(viewModel: viewModel)
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(localization.text(.featuredProducts))
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)

                            if viewModel.isProductsLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            } else {
                                ProductsGrid(
                                    products: viewModel.products,
                                    isFavorite: { favoritesStore.isFavorite(productId: $0) },
                                    onFavoriteTap: { product in
                                        viewModel.toggleFavorite(product: product, favoritesStore: favoritesStore)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .alert(localization.text(.removeFromFavorites), isPresented: $viewModel.showRemoveAlert, presenting: viewModel.productToRemove) { product in
                Button(localization.text(.cancel), role: .cancel) { }
                Button(localization.text(.remove), role: .destructive) {
                    viewModel.confirmRemoveFavorite(favoritesStore: favoritesStore)
                }
            } message: { product in
                Text(localization.format(.removeFromFavoritesMessage, product.title))
            }
            .alert(localization.text(.signInRequired), isPresented: $viewModel.showGuestAlert) {
                Button(localization.text(.cancel), role: .cancel) { }
                Button(localization.text(.signIn)) {
                    appState.isGuest = false
                    appState.currentRoute = .auth
                }
            } message: {
                Text(localization.text(.signInRequiredFavoritesMessage))
            }
            .onAppear {
                viewModel.isGuest = appState.isGuest
                viewModel.objectWillChange.send()
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppStateManager())
        .environmentObject(LocalizationManager())
        .environmentObject(FavoritesStore())
}
