//
//  ProductGrid.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 30/06/2026.
//

import SwiftUI

struct ProductsGrid: View {
    @ObservedObject var viewModel: HomeViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.fakeProducts?.products ?? [], id: \.id) { product in
                    ProductCard(viewModel: viewModel, product: product)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            .padding(.top, 12)
        }
    }
}

#Preview {
    
    let viewModel = HomeViewModel()
    
    return ProductsGrid(viewModel: viewModel)
}
