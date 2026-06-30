//
//  HomeHeader.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct HomeHeader: View {
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                Text("BUYZA")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    print("Cart tapped")
                }) {
                    Image(systemName: "cart")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.title3)
                
                TextField("What are you looking for?", text: $searchText)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .padding(.horizontal)
            
            Divider()
                .padding(.top, 6)
        }
        .padding(.top, 4)
        .background(Color.white.ignoresSafeArea(edges: .top)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 5))
        
    }
}

#Preview {
    HomeHeader()
}
