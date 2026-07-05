import Foundation

protocol GoogleLoginUseCaseProtocol {
    @MainActor func execute() async throws -> UserModel
}

struct GoogleLoginUseCase: GoogleLoginUseCaseProtocol {
    private let authRepository: AuthRepoProtocol
    
    init(authRepository: AuthRepoProtocol) {
        self.authRepository = authRepository
    }
    
    @MainActor
    func execute() async throws -> UserModel {
        do {
            return try await authRepository.loginWithGoogle()
        } catch {
            throw AuthError.map(error)
        }
    }
}
