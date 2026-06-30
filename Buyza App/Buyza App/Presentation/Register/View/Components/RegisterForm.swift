//
//  RegisterForm.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


//
//  RegisterForm.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import SwiftUI

struct RegisterForm: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text("FULL NAME")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                TextField("Ali Eldeep", text: $viewModel.name)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .modifier(InputFieldModifier())
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text("EMAIL ADDRESS")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                TextField("depo@example.com", text: $viewModel.email)
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
            }
        }
    }
}
