//
//  SearchResultsView.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 02/07/2026.
//

import SwiftUI

struct SearchResultsView: View {
    @StateObject private var viewModel: SearchResultsViewModel

    init(initialSearchText: String = "") {
        _viewModel = StateObject(
            wrappedValue: SearchResultsViewModel(initialSearchText: initialSearchText)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                SearchBarView(
                    text: $viewModel.searchText,
                    placeholder: viewModel.searchPlaceholder
                )

                HStack {
                    Button {
                        viewModel.isFilterSheetPresented = true
                    } label: {
                        Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                            .font(.subheadline)
                            .foregroundColor(viewModel.hasActiveFilters ? .black : .secondary)
                    }

                    if viewModel.hasActiveFilters {
                        Text("• Active")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if !viewModel.isLoading {
                        Text("\(viewModel.displayedProducts.count) items")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Text(viewModel.filterLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))

            ScrollView {
                content
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .sheet(isPresented: $viewModel.isFilterSheetPresented) {
            ProductFilterSheet(
                criteria: $viewModel.filterCriteria,
                productTypes: viewModel.availableProductTypes,
                vendors: viewModel.availableVendors,
                showsVendorFilter: viewModel.showsVendorFilter,
                onApply: { viewModel.applyFilters() },
                onReset: { viewModel.resetFilters() }
            )
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

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .padding(.top, 40)
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
        } else if viewModel.fetchedProducts.isEmpty {
            Text("No products found")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 40)
        } else if viewModel.displayedProducts.isEmpty {
            Text(emptyResultsMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 40)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        } else {
            ProductsGrid(
                products: viewModel.displayedProducts,
                isFavorite: viewModel.isFavorite(productID:),
                onFavoriteTap: { product in
                    viewModel.toggleFavorite(product: product)
                }
            )
        }
    }

    private var emptyResultsMessage: String {
        if !viewModel.searchText.isEmpty {
            return "No products match \"\(viewModel.searchText)\""
        }
        return "No products match the selected filters"
    }
}

#Preview {
    NavigationView {
        SearchResultsView(initialSearchText: "adidas")
    }
}
