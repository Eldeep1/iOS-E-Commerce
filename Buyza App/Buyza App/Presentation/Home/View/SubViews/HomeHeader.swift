//
//  HomeHeader.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct HomeHeader: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var navigateToCart = false
    @State private var showGuestAlert = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("BUYZA")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

                NavigationLink(destination: SearchResultsView()) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.trailing, 8)
                }

                Button(action: {
                    if appState.isGuest {
                        showGuestAlert = true
                    } else {
                        navigateToCart = true
                    }
                }) {
                    Image(systemName: "cart")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .background(
                    NavigationLink(destination: makeCartView(), isActive: $navigateToCart) {
                        EmptyView()
                    }
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            .padding(.top, 4)

            Divider()
                .padding(.top, 6)
        }
        .background(Color.white.ignoresSafeArea()
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 5))
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

    @MainActor private func makeCartView() -> some View {
        let repo = CartRepositoryImp()
        let fetchCartUseCase = FetchCartUseCase(repository: repo)
        let addToCartUseCase = AddToCartUseCase(repository: repo)
        let removeFromCartUseCase = RemoveFromCartUseCase(repository: repo)
        let updateQuantityUseCase = UpdateQuantityUseCase(repository: repo)
        let viewModel = CartViewModel(
            fetchCartUseCase: fetchCartUseCase,
            addToCartUseCase: addToCartUseCase,
            removeFromCartUseCase: removeFromCartUseCase,
            updateQuantityUseCase: updateQuantityUseCase
        )
        return CartView(viewModel: viewModel)
    }
}

#Preview {
    NavigationView {
        HomeHeader()
            .environmentObject(AppStateManager())
    }
}
