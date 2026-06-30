//
//  SplashViewModel.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import Foundation

import SwiftUI
import Combine

class SplashViewModel: ObservableObject {
    @Published var isSplashActive: Bool = true
    
    @Published var navigateToHome = false
    @Published var navigateToLogin = false
    private let checkLoginUseCase: CheckLoginStatusUseCase
    
    init(checkLoginUseCase: CheckLoginStatusUseCase) {
        self.checkLoginUseCase=checkLoginUseCase
    }
    
    func checkUserStatus(completion: @escaping (AppRoute) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
            
            let isLoggedIn = self.checkLoginUseCase.execute()
            
            if isLoggedIn {
                completion(.home)
            } else if !hasSeenOnboarding {
                completion(.onboarding)
            } else {
                completion(.auth)
            }
            
            // 4. Turn off splash state
            self.isSplashActive = false
        }
    }
}

