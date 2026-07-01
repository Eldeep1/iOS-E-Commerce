//
//  BrandsListView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 29/06/2026.
//

import SwiftUI

struct BrandsListView: View {
    @ObservedObject var viewModel : HomeViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHStack(spacing: 16) {
                ForEach(viewModel.brands, id: \.id) { index in
                    CollectionCell(collectionItem: index)
                }
            }
            .padding(.leading, 24)
            .padding(.trailing, 8)
        }
    }}

#Preview {
    BrandsListView(viewModel: HomeViewModel())
}
