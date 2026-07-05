//
//  LoginViewModel.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    @Published var loginSuccess = false
    
    private let loginUseCase: LoginUseCaseProtocol
    private let googleLoginUseCase: GoogleLoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol, googleLoginUseCase: GoogleLoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
        self.googleLoginUseCase = googleLoginUseCase
    }
    
    func signIn() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let userModel = try await loginUseCase.execute(email: email, password: password)
                print("Successfully logged in user: \(userModel.name)")
                self.loginSuccess = true
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
                self.isLoading = false
            }
        }
    }
    
    func signInWithGoogle() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let userModel = try await googleLoginUseCase.execute()
                print("Google login successful! Welcome \(userModel.name)")
                self.loginSuccess = true
            } catch {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
            }
            self.isLoading = false
        }
    }
}
