//
//  Buyza_AppApp.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }

    return true
  }
}

@main
struct Buyza_AppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var appState = AppStateManager()
    @StateObject private var localization = LocalizationManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootContainerView()
                .environmentObject(appState)
                .environmentObject(localization)
                .environment(\.layoutDirection, localization.layoutDirection)
                .environment(\.locale, Locale(identifier: localization.currentLanguage.localeIdentifier))
        }
    }
}
