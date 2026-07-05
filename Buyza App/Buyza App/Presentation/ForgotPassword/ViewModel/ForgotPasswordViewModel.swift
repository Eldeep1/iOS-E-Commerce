import Foundation

@MainActor
final class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    @Published var showSuccessAlert = false
    
    private let sendPasswordResetUseCase: SendPasswordResetUseCaseProtocol
    
    init(sendPasswordResetUseCase: SendPasswordResetUseCaseProtocol) {
        self.sendPasswordResetUseCase = sendPasswordResetUseCase
    }
    
    func sendResetLink() {
        guard !isLoading else { return }
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await sendPasswordResetUseCase.execute(email: cleanEmail)
                self.showSuccessAlert = true
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
                self.isLoading = false
            }
        }
    }
}
