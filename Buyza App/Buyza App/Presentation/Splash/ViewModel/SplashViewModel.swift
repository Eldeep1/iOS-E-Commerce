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
    
    init() {
        loadApplicationData()
    }
    
    private func loadApplicationData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.isSplashActive = false
            }
        }
    }
}
