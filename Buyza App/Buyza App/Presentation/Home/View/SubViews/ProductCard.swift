//
//  ProductCard.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 29/06/2026.
//

import SwiftUI

struct ProductCard: View {
    @ObservedObject var viewModel : HomeViewModel
    var product : Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack(alignment: .topTrailing) {
                
                let url = URL(string: product.images.first?.src ?? "")
                
                AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            
                } placeholder: {
                    Color(.systemGray4)
                }   
                .frame(width: 137, height: 145)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Button(action: {
            
                }) {
                    Image(viewModel.isFavorite(productID: Int(product.id)) ? "fav-filled" : "fav-stroke")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(6)
                        .background(Circle().fill(Color.white))
                }
                .padding(8)
            }
            .frame(width: 170)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 8, trailing: 0))
            
            
            VStack(alignment: .leading, spacing: 12) {
                Text(product.title)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(height: 44)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 4))
                
                
                Text(String(format: "$%.2f", Double(product.variants.first?.price ?? "0") ?? 0.0))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                    .padding(.bottom, 12)
            }
            
            Spacer()
            
        }
        .frame(width: 170, height: 255)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.gray.opacity(0.4), radius: 9, x: 0, y: 0)
    }
    
}
    
//struct  FakeProductResponse {
//    var products : [FakeProduct]
//}
//
//struct FakeProduct {
//    var id : Int
//    var title : String
//    var price : Float
//    var image : String
//}
//
//
//    #Preview {
//        let fakeProduct = FakeProduct(id: 1, title: "Sample Product Sample Product Sample Product", price: 29.99, image: "dummy-product")
//        
//        return ProductCard(viewModel: HomeViewModel(), product: fakeProduct)
//    }
