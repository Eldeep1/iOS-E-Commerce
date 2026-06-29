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
                let collection = viewModel.categories?.custom_collections ?? []
                
                ForEach(collection, id: \.id) { index in
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
    
    let dummyItem1 = Collection(
        id: 101,
        title: "ADIDAS",
        image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
    )
    
    let dummyItem2 = Collection(
        id: 102,
        title: "ADIDAS",
        image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
    )
    
    let dummyItem3 = Collection(
        id: 103,
        title: "ADIDAS",
        image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
    )
    
    
    let dummyItem4 = Collection(
        id: 104,
        title: "ADIDAS",
        image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
    )
    
    let dummyItem5 = Collection(
        id: 105,
        title: "ADIDAS",
        image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
    )
    
     mockViewModel.categories = CategoryResponse(custom_collections: [dummyItem1, dummyItem2, dummyItem3, dummyItem4, dummyItem5])
    
    return CategoriesListView(viewModel: mockViewModel)
}
