//
//  MainView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var selectedTab = 0
    @State private var showGuestAlert = false

    var selectionBinding: Binding<Int> {
        Binding {
            selectedTab
        } set: { newValue in
            if appState.isGuest && (newValue == 2) {
                showGuestAlert = true
            } else {
                selectedTab = newValue
            }
        }
    }

    init() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some View {
        TabView(selection: selectionBinding) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)

            FavoritesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "heart.fill" : "heart")
                }
                .tag(1)

            OrdersView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "shippingbox.fill" : "shippingbox")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                }
                .tag(3)
        }
        .tint(.black)
        .alert(localization.text(.signInRequired), isPresented: $showGuestAlert) {
            Button(localization.text(.cancel), role: .cancel) { }
            Button(localization.text(.signIn)) {
                appState.isGuest = false
                appState.currentRoute = .auth
            }
        } message: {
            Text(localization.text(.signInRequiredMessage))
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppStateManager())
        .environmentObject(LocalizationManager())
}
