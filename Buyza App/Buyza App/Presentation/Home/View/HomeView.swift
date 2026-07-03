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
            VStack {
                HomeHeader(
                    searchText: $searchText,
                    onSearchActivated: openSearchResults,
                    onSearch: openSearchResults
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {

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
                            Text("Recommendations")
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
                                    onFavoriteTap: { _ in }
                                )
                            }
                        }
                    }
                    .padding(.top, 8)
                }
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
