//
//  CollectionProductsView.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import SwiftUI

struct CollectionProductsView: View {
    @StateObject private var viewModel: CollectionProductsViewModel

    init(collection: Collection) {
        _viewModel = StateObject(
            wrappedValue: CollectionProductsViewModel(
                collectionId: collection.id ?? 0,
                collectionTitle: collection.title ?? ""
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
                    onFavoriteTap: { _ in }
                )
            }
        }
        .navigationTitle(viewModel.collectionTitle)
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        CollectionProductsView(
            collection: Collection(
                id: 1,
                title: "ADIDAS",
                image: NetworkImage(src: "")
            )
        )
    }
}
