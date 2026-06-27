//
//  SocialLogin.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI

struct SocialLogin: View {
    var body: some View {
        VStack(spacing: 16) {
           
            HStack {
                VStack { Divider().background(Color.gray.opacity(0.3)) }
                Text("OR")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.7))
                    .tracking(1)
                    .padding(.horizontal, 8)
                VStack { Divider().background(Color.gray.opacity(0.3)) }
            }
            .padding(.vertical, 8)
            
            // Social buttons
            HStack(spacing: 16) {
                SocialButton(imageName: "apple.logo") { print("Apple Auth") }
                SocialButton(imageName: "globe") { print("Google Auth") }
                SocialButton(imageName: "person.2.fill") { print("FB Auth") }
            }
        }
    }
}
