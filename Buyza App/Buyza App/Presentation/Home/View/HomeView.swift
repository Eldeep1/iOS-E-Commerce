//
//  HomeView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel : HomeViewModel = HomeViewModel()
    
    var body: some View {
            VStack(spacing: 20) {
                HomeHeader()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        EventsList()

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Categories")
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
                            Text("Brands")
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
                            Text("Featured Products")
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
                                    isFavorite: viewModel.isFavorite(productID:),
                                    onFavoriteTap: { product in
                                        viewModel.toggleFavorite(product: product)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .alert("Remove from Favorites?", isPresented: $viewModel.showRemoveAlert, presenting: viewModel.productToRemove) { product in
                Button("Cancel", role: .cancel) { }
                Button("Remove", role: .destructive) {
                    viewModel.confirmRemoveFavorite()
                }
            } message: { product in
                Text("Are you sure you want to remove \(product.title) from your favorites?")
            }
            .onAppear {
                viewModel.objectWillChange.send()
            }
    }
}

#Preview {
    HomeView()
}
