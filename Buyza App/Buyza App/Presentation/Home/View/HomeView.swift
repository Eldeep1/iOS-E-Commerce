//
//  HomeView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()

    @State private var searchText: String = ""
    @State private var isSearchActive = false
    @State private var searchInitialText: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HomeHeader(
                    searchText: $searchText,
                    onSearchActivated: openSearchResults,
                    onSearch: openSearchResults
                )
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
            .background(searchNavigationLink)
            .onChange(of: searchText, perform: handleSearchTextChange)
            .onChange(of: isSearchActive, perform: handleSearchNavigationChange)
        }
        .navigationViewStyle(.stack)
    }

    private var searchNavigationLink: some View {
        NavigationLink(
            destination: SearchResultsView(initialSearchText: searchInitialText),
            isActive: $isSearchActive,
            label: { EmptyView() }
        )
        .hidden()
    }

    private func openSearchResults() {
        searchInitialText = searchText

        if isSearchActive {
            isSearchActive = false
            DispatchQueue.main.async {
                isSearchActive = true
            }
        } else {
            isSearchActive = true
        }
    }

    private func handleSearchTextChange(_ newValue: String) {
        guard !isSearchActive, !newValue.isEmpty else { return }
        openSearchResults()
    }

    private func handleSearchNavigationChange(_ isActive: Bool) {
        if !isActive {
            searchText = ""
        }
    }
}

#Preview {
    HomeView()
}
