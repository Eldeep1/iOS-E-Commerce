//
//  LoginForm.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI

struct LoginForm: View {
    @ObservedObject var viewModel: LoginViewModel
    var onForgotPassword: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Email Input
            VStack(alignment: .leading, spacing: 8) {
                Text("EMAIL ADDRESS")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                TextField("name@example.com", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .modifier(InputFieldModifier())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                    Text("PASSWORD")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.gray)
                        .tracking(1)
                                    
                HStack {
                    if viewModel.isPasswordVisible {
                        TextField("••••••••", text: $viewModel.password)
                    } else {
                        SecureField("••••••••", text: $viewModel.password)
                    }
                    
                    Button(action: { viewModel.isPasswordVisible.toggle() }) {
                        Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .modifier(InputFieldModifier())
                HStack{
                    Spacer()
                    ForgotPasswordButton(action: onForgotPassword)
                }

            }
        }
    }
}
