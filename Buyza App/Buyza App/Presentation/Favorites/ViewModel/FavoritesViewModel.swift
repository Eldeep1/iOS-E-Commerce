//
//  FavoritesViewModel.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 03/07/2026.
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var showRemoveAlert = false
    @Published var productToRemove: Product?

    private let getFavoriteProductsUseCase: GetFavoriteProductsUseCaseProtocol

    init(getFavoriteProductsUseCase: GetFavoriteProductsUseCaseProtocol? = nil) {
        let favoritesRepo = FavoritesRepoImp(localDataSource: ProductLocalDataSource())
        self.getFavoriteProductsUseCase = getFavoriteProductsUseCase ?? GetFavoriteProductsUseCase(repository: favoritesRepo)
    }

    func fetchFavorites() {
        do {
            products = try getFavoriteProductsUseCase.execute()
        } catch {
            print("Error fetching favorites: \(error)")
        }
    }

    func toggleFavorite(product: Product, favoritesStore: FavoritesStore) {
        if favoritesStore.isFavorite(productId: product.id) {
            productToRemove = product
            showRemoveAlert = true
        } else {
            try? favoritesStore.add(product: product)
            fetchFavorites()
        }
    }

    func confirmRemoveFavorite(favoritesStore: FavoritesStore) {
        guard let product = productToRemove else { return }
        try? favoritesStore.remove(productId: product.id)
        fetchFavorites()
    }
}
