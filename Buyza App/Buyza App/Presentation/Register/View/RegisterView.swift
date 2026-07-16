//
//  RegisterView.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject private var localization: LocalizationManager
    
    init(registerUseCase: RegisterUseCaseProtocol, googleLoginUseCase: GoogleLoginUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: RegisterViewModel(registerUseCase: registerUseCase, googleLoginUseCase: googleLoginUseCase))
    }
    
    var formSection: some View {
        VStack(spacing: 20) {
            RegisterForm(viewModel: viewModel)
            
            Button(action: { viewModel.signUp() }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(localization.text(.signUp))
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
            .padding(.top, 8)
            
            AnotherLoginOptions(showGuestOption: false, onGoogleLogin: {
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
                    Spacer().frame(height: 20)
                    
                   
                    VStack(spacing: 8) {
                        Text(localization.text(.createAccount))
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(localization.text(.joinBuyza))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    formSection
                    
                    Spacer().frame(height: 20)
                    
                   
                    HStack(spacing: 4) {
                        Text(localization.text(.alreadyHaveAccount))
                            .foregroundColor(.gray)
                        Button(localization.text(.signIn)) {
                            dismiss()
                        }
                        .foregroundColor(.black)
                    }
                    .font(.system(size: 15))
                    .padding(.bottom, 40)
                }
            }
        }.onChange(of: viewModel.registrationSuccess) { newValue in
            if newValue {
                appState.currentRoute = .home
            }
        }
        .alert(localization.text(.registrationIssue), isPresented: $viewModel.showErrorAlert, actions: {
            Button(localization.text(.ok), role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage ?? localization.text(.error))
        })
        .alert(localization.text(.checkYourEmail), isPresented: $viewModel.showSuccessAlert, actions: {
            Button(localization.text(.ok), role: .cancel) {
                dismiss()
            }
        }, message: {
            Text(localization.text(.verificationEmailSent))
        })
    }
}
