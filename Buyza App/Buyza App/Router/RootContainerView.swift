//
//  RootContainerView.swift
//  Buyza App
//
//  Created by depo on 29/06/2026.
//

import SwiftUI

struct RootContainerView: View {
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject var localization: LocalizationManager
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
                            firebaseService: FirebaseServices(), shopifyService: ShopifyAuthService(), localDataSource: KeychainService.shared)),
                        googleLoginUseCase: GoogleLoginUseCase(authRepository: AuthRepoImp(firebaseService: FirebaseServices(), shopifyService: ShopifyAuthService(), localDataSource: KeychainService.shared))
                    )
                }
                .environmentObject(appState)
            case .home:
                HomeNavContainer()
                    .environmentObject(appState)
            }
        }
        .id(localization.currentLanguage.rawValue)
        .animation(.easeInOut, value: appState.currentRoute)
    }
}

struct HomeNavContainer: View {
    @State private var navID = UUID()
    
    var body: some View {
        NavigationView {
            MainTabView()
        }
        .id(navID)
        .onReceive(NotificationCenter.default.publisher(for: .popToRoot)) { _ in
            navID = UUID()
        }
    }
}
