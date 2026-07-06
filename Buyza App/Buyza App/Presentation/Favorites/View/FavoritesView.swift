//
//  FavoritesView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(localization.text(.favorites))
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    if appState.isGuest {
                        VStack(alignment: .center, spacing: 16) {
                            Image(systemName: "heart.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.black)
                                .padding(.bottom, 8)
                                
                            Text("No favorites yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                
                            Text("To add products to your favorites, sign in")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                
                            Button(action: {
                                appState.isGuest = false
                                appState.currentRoute = .auth
                            }) {
                                Text(localization.text(.signIn))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(12)
                            }
                            .padding(.top, 16)
                            .padding(.horizontal, 32)
                        }
                        .frame(maxWidth: .infinity, minHeight: 400)
                        .padding(.vertical, 80)
                    } else if viewModel.products.isEmpty {
                        VStack(alignment: .center) {
                            Image(systemName: "heart.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.black)
                                .padding(.bottom, 16)
                            Text(localization.text(.noFavoritesYet))
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
            .alert(localization.text(.removeFromFavorites), isPresented: $viewModel.showRemoveAlert, presenting: viewModel.productToRemove) { product in
                Button(localization.text(.cancel), role: .cancel) { }
                Button(localization.text(.remove), role: .destructive) {
                    viewModel.confirmRemoveFavorite()
                }
            } message: { product in
                Text(localization.format(.removeFromFavoritesMessage, product.title))
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(LocalizationManager())
}
