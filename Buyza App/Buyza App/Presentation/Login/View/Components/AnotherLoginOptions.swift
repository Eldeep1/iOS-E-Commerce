//
//  SocialLogin.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI

struct AnotherLoginOptions: View {
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject private var localization: LocalizationManager
    var showGuestOption: Bool = true
    var onGoogleLogin: () -> Void
        
        var body: some View {
            VStack(spacing: 16) {
               
                HStack {
                    VStack { Divider().background(Color.gray.opacity(0.3)) }
                    Text(localization.text(.or))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.gray.opacity(0.7))
                        .tracking(1)
                        .padding(.horizontal, 8)
                    VStack { Divider().background(Color.gray.opacity(0.3)) }
                }
                .padding(.vertical, 8)
                
                VStack(spacing: 12) {
                    Button(action: {
                        onGoogleLogin()
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.system(size: 18))
                            Text(localization.text(.continueWithGoogle))
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                    
                    Button(action: {
                        withAnimation {
                            appState.isGuest = true
                            appState.currentRoute = .home
                        }
                    }) {
                        Text(localization.text(.continueAsGuest))
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
