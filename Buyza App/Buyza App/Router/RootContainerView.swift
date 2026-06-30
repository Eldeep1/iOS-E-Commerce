//
//  RootContainerView.swift
//  Buyza App
//
//  Created by depo on 29/06/2026.
//

import SwiftUI

struct RootContainerView: View {
    @EnvironmentObject var appState: AppStateManager
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        Group {
            switch appState.currentRoute {
            case .splash:
                SplashView(
                    viewModel: SplashViewModel(checkLoginUseCase: CheckLoginStatusUseCase(authRepository: AuthRepoImp(firebaseService: FirebaseServices(), shopifyService: ShopifyAuthService(), localDataSource: KeychainService.shared)
                                              )
                ))
                    .environmentObject(appState)
            case .onboarding:
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environmentObject(appState)
            case .auth:
                NavigationView {
                    LoginView(
                        loginUseCase: LoginUseCase(authRepository: AuthRepoImp(
                            firebaseService: FirebaseServices(), shopifyService: ShopifyAuthService(), localDataSource: KeychainService.shared))
                    )
                }
                .environmentObject(appState)
            case .home:
                tmpHome()
                    .environmentObject(appState)
            }
        }.animation(.easeInOut, value: appState.currentRoute)
    }
}
