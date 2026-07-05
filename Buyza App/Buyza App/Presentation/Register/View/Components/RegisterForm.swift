//
//  RegisterForm.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import SwiftUI

struct RegisterForm: View {
    @ObservedObject var viewModel: RegisterViewModel
    @EnvironmentObject private var localization: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(localization.text(.fullName))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                TextField("Ali Eldeep", text: $viewModel.name)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .modifier(InputFieldModifier())
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(localization.text(.emailAddress))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                ZStack(alignment: .leading) {
                    if viewModel.email.isEmpty {
                        Text(verbatim: "depo@example.com")
                            .foregroundColor(Color.gray.opacity(0.6))
                    }
                    TextField("", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.black)
                        .tint(.black)
                }
                .modifier(InputFieldModifier())
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(localization.text(.password))
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
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(localization.text(.confirmPassword))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                HStack {
                    if viewModel.isConfirmPasswordVisible {
                        TextField("••••••••", text: $viewModel.confirmPassword)
                    } else {
                        SecureField("••••••••", text: $viewModel.confirmPassword)
                    }
                    
                    Button(action: { viewModel.isConfirmPasswordVisible.toggle() }) {
                        Image(systemName: viewModel.isConfirmPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .modifier(InputFieldModifier())
            }
        }
    }
}
