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
    @EnvironmentObject private var localization: LocalizationManager
    init(loginUseCase: LoginUseCaseProtocol, googleLoginUseCase: GoogleLoginUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(loginUseCase: loginUseCase, googleLoginUseCase: googleLoginUseCase))
    }
    @State private var showForgotPassword = false
    
    var formSection: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: ForgotPasswordView(sendPasswordResetUseCase: SendPasswordResetUseCase(authRepository: AuthRepoImp(firebaseService: FirebaseServices(), shopifyService: ShopifyAuthService(), localDataSource: KeychainService.shared))), isActive: $showForgotPassword) {
                EmptyView()
            }
            
            LoginForm(viewModel: viewModel) {
                showForgotPassword = true
            }
            
            LoginButton(viewModel: viewModel)
                .padding(.top, 8)
            
            AnotherLoginOptions(showGuestOption: true, onGoogleLogin: {
                viewModel.signInWithGoogle()
            })
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(28)
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.93, green: 0.92, blue: 0.98), Color(red: 0.96, green: 0.96, blue: 0.98)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Spacer().frame(height: 40)
                    
                    LoginHeader()
                    
                    formSection
                    
                    Spacer().frame(height: 20)
                    
                    LoginFooter()
                        .padding(.bottom, 40)
                }
            }
        }
        .alert(localization.text(.authenticationIssue), isPresented: $viewModel.showErrorAlert, actions: {
            Button(localization.text(.ok), role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage ?? localization.text(.error))
        }).onChange(of: viewModel.loginSuccess) { success in
            if success {
                withAnimation {
                    appState.currentRoute = .home
                }
            }
        }
    }
}
