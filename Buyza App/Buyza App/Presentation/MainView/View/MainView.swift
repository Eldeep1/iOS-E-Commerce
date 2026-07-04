//
//  MainView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
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
        TabView(selection: $selectedTab) {
            
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
        
    }
}

#Preview {
    MainTabView()
}
