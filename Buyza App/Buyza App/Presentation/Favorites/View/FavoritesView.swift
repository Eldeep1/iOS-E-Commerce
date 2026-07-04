//
//  FavoritesView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Favorites")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    if viewModel.products.isEmpty {
                        VStack(alignment: .center) {
                            Image(systemName: "heart.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.black)
                                .padding(.bottom, 16)
                            Text("No favorites yet")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, minHeight: 400)
                        .padding(.vertical, 80)
                    } else {
                        ProductsGrid(
                            products: viewModel.products,
                            isFavorite: viewModel.isFavorite(productID:),
                            onFavoriteTap: { product in
                                viewModel.toggleFavorite(product: product)
                            }
                        )
                    }
                }
            }
            .padding(.top, 4)
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchFavorites()
            }
            .alert("Remove from Favorites?", isPresented: $viewModel.showRemoveAlert, presenting: viewModel.productToRemove) { product in
                Button("Cancel", role: .cancel) { }
                Button("Remove", role: .destructive) {
                    viewModel.confirmRemoveFavorite()
                }
            } message: { product in
                Text("Are you sure you want to remove \(product.title) from your favorites?")
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    FavoritesView()
}
