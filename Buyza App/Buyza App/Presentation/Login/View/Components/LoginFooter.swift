//
//  LoginFooter.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI
struct LoginFooter: View {
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        HStack(spacing: 4) {
            Text(localization.text(.newToBuyza))
                .foregroundColor(.gray)
            NavigationLink(destination: RegisterView(
                registerUseCase: RegisterUseCase(
                    authRepository: AuthRepoImp(
                        firebaseService: FirebaseServices(),
                        shopifyService: ShopifyAuthService(),
                        localDataSource: KeychainService.shared
                    )
                ),
                googleLoginUseCase: GoogleLoginUseCase(
                    authRepository: AuthRepoImp(
                        firebaseService: FirebaseServices(),
                        shopifyService: ShopifyAuthService(),
                        localDataSource: KeychainService.shared
                    )
                )
            )) {
                Text(localization.text(.createAccount))
                    .foregroundColor(.black)
            }
        }
        .font(.system(size: 15))
    }
}
