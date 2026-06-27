//
//  LoginFooter.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI
struct LoginFooter: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("New to Buyza?")
                .foregroundColor(.gray)
            NavigationLink(destination: RegisterView(registerUseCase: RegisterUseCase(authRepository: AuthRepoImp(authService: FirebaseServices())))) {
                Text("Create Account")
                    .foregroundColor(.black)
            }
        }
        .font(.system(size: 15))
    }
}
