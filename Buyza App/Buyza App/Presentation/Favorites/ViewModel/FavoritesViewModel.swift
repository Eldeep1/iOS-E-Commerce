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
    
    @Published var showRemoveAlert: Bool = false
    @Published var productToRemove: Product?
    
    private let getFavoriteProductsUseCase: GetFavoriteProductsUseCaseProtocol
    private let checkIsFavoriteUseCase: CheckIsFavoriteUseCaseProtocol
    private let saveFavoriteUseCase: SaveFavoriteUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    
    init(
        getFavoriteProductsUseCase: GetFavoriteProductsUseCaseProtocol? = nil,
        checkIsFavoriteUseCase: CheckIsFavoriteUseCaseProtocol? = nil,
        saveFavoriteUseCase: SaveFavoriteUseCaseProtocol? = nil,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol? = nil
    ) {
        let favoritesRepo = FavoritesRepoImp(localDataSource: ProductLocalDataSource())
        
        self.getFavoriteProductsUseCase = getFavoriteProductsUseCase ?? GetFavoriteProductsUseCase(repository: favoritesRepo)
        self.checkIsFavoriteUseCase = checkIsFavoriteUseCase ?? CheckIsFavoriteUseCase(repository: favoritesRepo)
        self.saveFavoriteUseCase = saveFavoriteUseCase ?? SaveFavoriteUseCase(repository: favoritesRepo)
        self.removeFavoriteUseCase = removeFavoriteUseCase ?? RemoveFavoriteUseCase(repository: favoritesRepo)
        
        fetchFavorites()
    }
    
    func fetchFavorites() {
        do {
            self.products = try getFavoriteProductsUseCase.execute()
        } catch {
            print("Error fetching favorites: \(error)")
        }
    }
    
    func isFavorite(productID: Int64) -> Bool {
        return (try? checkIsFavoriteUseCase.execute(productId: productID)) ?? false
    }
    
    func toggleFavorite(product: Product) {
        do {
            let isFav = try checkIsFavoriteUseCase.execute(productId: product.id)
            if isFav {
                self.productToRemove = product
                self.showRemoveAlert = true
            } else {
                try saveFavoriteUseCase.execute(product: product)
                fetchFavorites()
                self.objectWillChange.send()
            }
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
    
    func confirmRemoveFavorite() {
        guard let product = productToRemove else { return }
        do {
            try removeFavoriteUseCase.execute(productId: product.id)
            fetchFavorites()
            self.objectWillChange.send()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
}
