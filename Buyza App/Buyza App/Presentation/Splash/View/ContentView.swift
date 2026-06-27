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
    
    var body: some View {
        Group {
            if viewModel.isSplashActive {
                SplashView()
            } else {
                
            }
        }
    }
}
