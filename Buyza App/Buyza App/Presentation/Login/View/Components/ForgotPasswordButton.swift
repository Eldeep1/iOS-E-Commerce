//
//  ForgotPasswordButton.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI

struct ForgotPasswordButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Forgot password?")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.blue)
        }
    }
}