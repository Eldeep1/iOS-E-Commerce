//
//  LoginViewHeader.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import SwiftUI

struct LoginViewHeader: View {
    var body: some View {
        Spacer().frame(height: 40)
        
        VStack(spacing: 8) {
            Text("Welcome Back")
                .font(.system(size: 34, weight: .bold, design: .default))
                .foregroundColor(.black)
            
            Text("Sign in to your secure Buyza account")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
