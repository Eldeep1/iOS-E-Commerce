//
//  SettingsViewModel.swift
//  Buyza App
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isLoggingOut = false
    @Published var showLogoutAlert = false
    @Published var showLanguageSheet = false
    @Published var showSignInAlert = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false

    private let logoutUseCase: LogoutUseCase

    init(logoutUseCase: LogoutUseCase? = nil) {
        let authRepo = AuthRepoImp(
            firebaseService: FirebaseServices(),
            shopifyService: ShopifyAuthService(),
            localDataSource: KeychainService.shared
        )
        self.logoutUseCase = logoutUseCase ?? LogoutUseCase(repo: authRepo)
    }

    func logout(appState: AppStateManager) {
        Task {
            isLoggingOut = true
            errorMessage = nil
            do {
                try await logoutUseCase.execute()
                appState.isGuest = false
                appState.currentRoute = .auth
            } catch {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
            isLoggingOut = false
        }
    }
}
