//
//  CollectionProductsView.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 02/07/2026.
//

import SwiftUI

struct CollectionProductsView: View {
    @StateObject private var viewModel: CollectionProductsViewModel

    init(collection: Collection, source: CollectionProductsSource) {
        _viewModel = StateObject(
            wrappedValue: CollectionProductsViewModel(
                collectionTitle: collection.title ?? "",
                source: source
            )
        )
    }

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 40)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            } else if viewModel.products.isEmpty {
                Text("No products found")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
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
        .navigationTitle(viewModel.collectionTitle)
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemBackground))
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
    NavigationView {
        CollectionProductsView(
            collection: Collection(
                id: 1,
                title: "ADIDAS",
                image: NetworkImage(src: "")
            ),
            source: .brand(vendor: "ADIDAS")
        )
    }
}
