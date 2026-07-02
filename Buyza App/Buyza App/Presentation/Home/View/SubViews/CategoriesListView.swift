//
//  CategoriesListView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 29/06/2026.
//

import SwiftUI

struct CategoriesListView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.categories, id: \.id) { category in
                    if let _ = category.id {
                        NavigationLink {
                            CollectionProductsView(collection: category)
                        } label: {
                            CollectionCell(collectionItem: category)
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
        CategoriesListView(viewModel: HomeViewModel())
    }
}
