//
//  HomeHeader.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct HomeHeader: View {
    @Binding var searchText: String
    var onSearchActivated: () -> Void
    var onSearch: () -> Void

    init(
        searchText: Binding<String>,
        onSearchActivated: @escaping () -> Void,
        onSearch: @escaping () -> Void
    ) {
        _searchText = searchText
        self.onSearchActivated = onSearchActivated
        self.onSearch = onSearch
    }

    var body: some View {
        VStack(spacing: 16) {

            HStack {
                Text("BUYZA")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

                NavigationLink(destination: makeCartView()) {
                    Image(systemName: "cart")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 4)

            HStack {
                SearchBarView(
                    text: $searchText,
                    placeholder: "What are you looking for?",
                    onSubmit: onSearch,
                    onIconTap: onSearchActivated
                )
            }
            .padding(.horizontal)

            Divider()
                .padding(.top, 6)
        }
        .padding(.top, 4)
        .background(Color.white.ignoresSafeArea(edges: .top)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 5))
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
    HomeHeader(
        searchText: .constant(""),
        onSearchActivated: {},
        onSearch: {}
    )
}
