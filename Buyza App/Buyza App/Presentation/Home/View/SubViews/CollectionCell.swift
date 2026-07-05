//
//  CategoryCell.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct CollectionCell: View {
    var collectionItem : Collection?
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
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
            .frame(width: 110, height: 110)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            
            Text(collectionItem?.title ?? "Unknown")
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(.black)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: 100, alignment: .center)
                .opacity(0.9)
        }
        .frame(width: 130)
        .onLongPressGesture(minimumDuration: 0.1, perform: {}) { isPressed in
            self.isPressed = isPressed
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
