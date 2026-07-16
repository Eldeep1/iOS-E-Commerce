//
//  AppRoute.swift
//  Buyza App
//
//  Created by depo on 29/06/2026.
//


import SwiftUI

enum AppRoute {
    case splash
    case onboarding
    case auth
    case home
}

class AppStateManager: ObservableObject {
    @Published var currentRoute: AppRoute = .splash
    @Published var isGuest: Bool = false
}
