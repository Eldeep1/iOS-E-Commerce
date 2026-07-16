//
//  ProductGrid.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 30/06/2026.
//

import SwiftUI

struct ProductsGrid: View {
    let products: [Product]
    var isFavorite: (Int64) -> Bool = { _ in false }
    var onFavoriteTap: (Product) -> Void = { _ in }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(products) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductCard(
                        product: product,
                        isFavorite: isFavorite(product.id),
                        onFavoriteTap: { onFavoriteTap(product) }
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .padding(.top, 12)
    }
}

#Preview {
    ScrollView {
        ProductsGrid(products: [])
    }
}
