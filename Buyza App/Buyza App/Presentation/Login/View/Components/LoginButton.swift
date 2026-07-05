//
//  LoginButton.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI

struct LoginButton: View {
    @ObservedObject var viewModel: LoginViewModel
    @EnvironmentObject private var localization: LocalizationManager
    
    var body: some View {
        Button(action: { viewModel.signIn() }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(localization.text(.signIn))
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.black)
            .clipShape(Capsule())
        }
        .disabled(viewModel.isLoading)
    }
}
