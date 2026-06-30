//
//  EmptyCartView.swift
//  Buyza App
//
//  Created by Antigravity on 30/06/2026.
//

import SwiftUI

struct EmptyCartView: View {
    var onShopNowTap: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 140, height: 140)
                
                Image(systemName: "bag.badge.plus")
                    .font(.system(size: 56, weight: .light))
                    .foregroundColor(.primary)
                    .offset(x: -2)
            }
            
            VStack(spacing: 12) {
                Text("Your Cart is Empty")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Looks like you haven't added anything to your cart yet. Explore our curated collections to find your style.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Button(action: onShopNowTap) {
                Text("Start Shopping")
                    .font(.headline)
                    .foregroundColor(Color(.systemBackground))
                    .frame(height: 54)
                    .frame(maxWidth: 240)
                    .background(Color.primary)
                    .cornerRadius(27)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    EmptyCartView()
}
