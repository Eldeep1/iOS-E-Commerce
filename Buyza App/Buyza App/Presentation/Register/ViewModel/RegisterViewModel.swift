//
//  RegisterViewModel.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


//
//  RegisterViewModel.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isPasswordVisible = false
    @Published var isConfirmPasswordVisible = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    @Published var showSuccessAlert = false
    @Published var registrationSuccess = false
    
    private let registerUseCase: RegisterUseCaseProtocol
    private let googleLoginUseCase: GoogleLoginUseCaseProtocol
    
    init(registerUseCase: RegisterUseCaseProtocol, googleLoginUseCase: GoogleLoginUseCaseProtocol) {
        self.registerUseCase = registerUseCase
        self.googleLoginUseCase = googleLoginUseCase
    }
    
    func signUp() {
        guard !isLoading else { return }
        
        
        let cleanFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanName = "\(cleanFirstName) \(cleanLastName)".trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard password == confirmPassword else {
            errorMessage = L10n.passwordsDoNotMatch.text(for: AppLanguage.stored)
            showErrorAlert = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                
                let userModel = try await registerUseCase.execute(
                    email: cleanEmail,
                    password: password,
                    firstName: cleanFirstName,
                    lastName: cleanLastName
                )
                
                print("Successfully registered domain user: \(userModel.name)")
                self.showSuccessAlert = true
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
                self.registrationSuccess = true
            } catch {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
            }
            self.isLoading = false
        }
    }
}
