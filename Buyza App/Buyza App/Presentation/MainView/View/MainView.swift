//
//  MainView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var selectedTab = 0
    @State private var showGuestAlert = false
    
    var selectionBinding: Binding<Int> {
        Binding {
            selectedTab
        } set: { newValue in
            if appState.isGuest && (newValue == 1 || newValue == 2 || newValue == 3) {
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
            
            Text("Cart View Placeholder")
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "cart.fill" : "cart")
                }
                .tag(2)
            
            OrdersView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "shippingbox.fill" : "shippingbox")
                }
                .tag(3)
        }
        .tint(.black)
        .alert("Sign In Required", isPresented: $showGuestAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign In") {
                appState.isGuest = false
                appState.currentRoute = .auth
            }
        } message: {
            Text("Please sign in to access Favorites, Cart, and Orders. It only takes a moment!")
        }
        
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppStateManager())
}
