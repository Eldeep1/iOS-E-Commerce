//
//  InputFieldModifier.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI

struct InputFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemGray6).opacity(0.6))
            .cornerRadius(8)
    }
}

