//
//  CategoryCell.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct CategoryCell: View {
    let iconName: String
    let title: String
    
    var body: some View {
        
        VStack(spacing: 16) {
            Image(iconName)
                .font(.largeTitle)
                .foregroundColor(.black)
                .frame(width: 110, height: 110)
                .background(
                    Circle()
                        .fill(Color(.systemGray4))
                        .overlay(
                            Circle()
                                .stroke(Color(.systemGray3), lineWidth: 1)
                        )
                )
            
            Text(title)
                .font(.title2)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    CategoryCell(iconName: "ic_fashion", title: "Fashion")
}
