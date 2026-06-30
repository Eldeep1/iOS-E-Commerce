//
//  LoginHeader.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI

struct LoginHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Welcome Back")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)
            
            Text("Sign in to your secure Buyza account")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}