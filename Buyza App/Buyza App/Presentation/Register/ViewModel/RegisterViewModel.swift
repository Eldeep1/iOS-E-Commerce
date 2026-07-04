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
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isPasswordVisible = false
    @Published var isConfirmPasswordVisible = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    @Published var registrationSuccess = false
    
    private let registerUseCase: RegisterUseCaseProtocol
    
    init(registerUseCase: RegisterUseCaseProtocol) {
        self.registerUseCase = registerUseCase
    }
    
    func signUp() {
        guard !isLoading else { return }
        
        
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
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
                    name: cleanName
                )
                
                print("Successfully registered domain user: \(userModel.name)")
                self.registrationSuccess = true
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
                self.isLoading = false
            }
        }
    }
}
