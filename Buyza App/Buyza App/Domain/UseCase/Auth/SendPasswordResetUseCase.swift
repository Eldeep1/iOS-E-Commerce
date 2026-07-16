import Foundation

protocol SendPasswordResetUseCaseProtocol {
    func execute(email: String) async throws
}

struct SendPasswordResetUseCase: SendPasswordResetUseCaseProtocol {
    private let authRepository: AuthRepoProtocol
    
    init(authRepository: AuthRepoProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(email: String) async throws {
        guard email.contains("@") && email.count > 5 else {
            throw AuthError.invalidEmail
        }
        do {
            try await authRepository.sendPasswordReset(email: email)
        } catch {
            throw AuthError.map(error)
        }
    }
}
