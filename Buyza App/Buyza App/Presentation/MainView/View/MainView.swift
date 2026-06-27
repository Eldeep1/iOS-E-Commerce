//
//  MainView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            Text("Favorites View Placeholder")
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "heart.fill" : "heart")
                }
                .tag(1)
            
            Text("Cart View Placeholder")
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "cart.fill" : "cart")
                }
                .tag(2)
            
            Text("Profile View Placeholder")
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                }
                .tag(3)
        }
        .tint(.black)
    }
}

#Preview {
    MainTabView()
}
