//
//  ContentView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SplashViewModel()
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        Group {
            if viewModel.isSplashActive {
                SplashView()
            } else if !hasSeenOnboarding {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            } else {

            }
        }
    }
}
