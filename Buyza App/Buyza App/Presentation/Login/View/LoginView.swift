//
//  LoginView.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI


struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject var appState: AppStateManager
    init(loginUseCase: LoginUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(loginUseCase: loginUseCase))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.93, green: 0.92, blue: 0.98), Color(red: 0.96, green: 0.96, blue: 0.98)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                LoginHeader()
                
                
                VStack(spacing: 20) {
                    LoginForm(viewModel: viewModel) {
                        print("Forgot password tapped")
                    }
                    
                    LoginButton(viewModel: viewModel)
                        .padding(.top, 8)
                    
                    SocialLogin()
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                
                Spacer()
                
                LoginFooter()
                    .padding(.bottom, 16)
            }
        }
        .alert("Authentication Issue", isPresented: $viewModel.showErrorAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage ?? "An unexpected error occurred.")
        }).onChange(of: viewModel.loginSuccess) { success in
            if success {
                withAnimation {
                    appState.currentRoute = .home
                }
            }
        }
    }
}
