//
//  HomeView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel : HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack{
            HomeHeader()
            
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
