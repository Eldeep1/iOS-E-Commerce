//
//  CategoriesListView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 29/06/2026.
//

import SwiftUI

struct CategoriesListView: View {
    @ObservedObject var viewModel : HomeViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHStack(spacing: 16) {
                ForEach(viewModel.categories, id: \.id) { index in
                    CollectionCell(collectionItem: index)
                }
            }
            .padding(.leading, 24) 
            .padding(.trailing, 8)
        }
    }
}

#Preview {
    let mockViewModel = HomeViewModel()
    
    return CategoriesListView(viewModel: mockViewModel)
}
