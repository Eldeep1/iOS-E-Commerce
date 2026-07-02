//
//  BrandsListView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 29/06/2026.
//

import SwiftUI

struct BrandsListView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.brands, id: \.id) { brand in
                    if let _ = brand.id {
                        NavigationLink {
                            CollectionProductsView(collection: brand)
                        } label: {
                            CollectionCell(collectionItem: brand)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.leading, 24)
            .padding(.trailing, 8)
        }
    }
}

#Preview {
    NavigationStack {
        BrandsListView(viewModel: HomeViewModel())
    }
}
