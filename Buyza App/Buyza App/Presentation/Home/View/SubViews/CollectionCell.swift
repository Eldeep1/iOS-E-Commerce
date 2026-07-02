//
//  CategoryCell.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct CollectionCell: View {
    var collectionItem : Collection?
    
    var body: some View {
        VStack(spacing: 14) {
            
            let imageUrl = URL(string: collectionItem?.image?.src ?? "")
            
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("empty-img")
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.systemGray3), lineWidth: 1)
            )
            
            Text(collectionItem?.title ?? "Unknown")
                .font(.subheadline)
                .foregroundColor(.black)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 80, height: 30)
        }
    }
}

#Preview {
    CollectionCell(collectionItem: Collection(
        id: 101,
        title: "ADIDAS",
        image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
    ))
}
