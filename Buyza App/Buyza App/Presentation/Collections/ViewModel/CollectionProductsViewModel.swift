//
//  CollectionProductsViewModel.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 02/07/2026.
//

import Foundation

@MainActor
final class CollectionProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var favoriteIDs: Set<Int64> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    let collectionTitle: String
    private let source: CollectionProductsSource

    private let getProductsByCollectionUseCase: GetProductsByCollectionUseCaseProtocol
    private let getProductsByVendorUseCase: GetProductsByVendorUseCaseProtocol
    
    private let saveFavoriteUseCase: SaveFavoriteUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol

    init(
        collectionTitle: String,
        source: CollectionProductsSource,
        getProductsByCollectionUseCase: GetProductsByCollectionUseCaseProtocol? = nil,
        getProductsByVendorUseCase: GetProductsByVendorUseCaseProtocol? = nil,
        saveFavoriteUseCase: SaveFavoriteUseCaseProtocol? = nil,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol? = nil
    ) {
        self.collectionTitle = collectionTitle
        self.source = source
        
        let collectionRepo = CollectionRepoImp(
            remoteDataSource: CollectionRemoteDataSource(),
            localDataSource: ProductLocalDataSource()
        )

        self.getProductsByCollectionUseCase = getProductsByCollectionUseCase ?? GetProductsByCollectionUseCase(repository: collectionRepo)
        self.getProductsByVendorUseCase = getProductsByVendorUseCase ?? GetProductsByVendorUseCase(repository: collectionRepo)
        
        self.saveFavoriteUseCase = saveFavoriteUseCase ?? SaveFavoriteUseCase(repository: collectionRepo)
        self.removeFavoriteUseCase = removeFavoriteUseCase ?? RemoveFavoriteUseCase(repository: collectionRepo)
        
        fetchProducts()
    }

    func fetchProducts() {
        Task {
            isLoading = true
            do {
                switch source {
                case .category(let collectionId):
                    products = try await getProductsByCollectionUseCase.execute(collectionId: collectionId)
                case .brand(let vendor):
                    products = try await getProductsByVendorUseCase.execute(vendor: vendor)
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    
    func toggleFavorite(product: Product) {
        let isFav = favoriteIDs.contains(product.id)
        do {
            if isFav {
                try removeFavoriteUseCase.execute(productId: product.id)
                favoriteIDs.remove(product.id)
            } else {
                try saveFavoriteUseCase.execute(product: product)
                favoriteIDs.insert(product.id)
            }
        } catch {
            print("Error toggling favorite: \(error)")
            self.errorMessage = "Failed to update favorites"
        }
    }
}
