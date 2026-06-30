//
//  SplashView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @EnvironmentObject var appState: AppStateManager
    @StateObject var viewModel: SplashViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            Image("BUYZA")
                .scaledToFit()
                .frame(width: 450, height: 450)
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .opacity(isAnimating ? 1.0 : 0.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0)) {
                        isAnimating = true
                    }
          }
        }.onAppear{
            viewModel.checkUserStatus { nextRoute in
                withAnimation {
                    appState.currentRoute = nextRoute
                }
            }
        }
    }
}
