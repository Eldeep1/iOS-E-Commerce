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
    
    @Published var showRemoveAlert: Bool = false
    @Published var productToRemove: Product?
    
    @Published var isLoading = false
    @Published var errorMessage: String?

    let collectionTitle: String
    private let source: CollectionProductsSource

    private let getProductsByCollectionUseCase: GetProductsByCollectionUseCaseProtocol
    private let getProductsByVendorUseCase: GetProductsByVendorUseCaseProtocol
    
    private let saveFavoriteUseCase: SaveFavoriteUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    private let checkIsFavoriteUseCase: CheckIsFavoriteUseCaseProtocol

    init(
        collectionTitle: String,
        source: CollectionProductsSource,
        getProductsByCollectionUseCase: GetProductsByCollectionUseCaseProtocol? = nil,
        getProductsByVendorUseCase: GetProductsByVendorUseCaseProtocol? = nil,
        saveFavoriteUseCase: SaveFavoriteUseCaseProtocol? = nil,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol? = nil,
        checkIsFavoriteUseCase: CheckIsFavoriteUseCaseProtocol? = nil
    ) {
        self.collectionTitle = collectionTitle
        self.source = source
        
        let collectionRepo = CollectionRepoImp(
            remoteDataSource: CollectionRemoteDataSource(),
            localDataSource: ProductLocalDataSource())

        self.getProductsByCollectionUseCase = getProductsByCollectionUseCase ?? GetProductsByCollectionUseCase(repository: collectionRepo)
        self.getProductsByVendorUseCase = getProductsByVendorUseCase ?? GetProductsByVendorUseCase(repository: collectionRepo)
        
        self.saveFavoriteUseCase = saveFavoriteUseCase ?? SaveFavoriteUseCase(repository: collectionRepo)
        self.removeFavoriteUseCase = removeFavoriteUseCase ?? RemoveFavoriteUseCase(repository: collectionRepo)
        self.checkIsFavoriteUseCase = checkIsFavoriteUseCase ?? CheckIsFavoriteUseCase(repository: collectionRepo)
        
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
                self.objectWillChange.send() // Trigger UI update
            }
        } catch {
            print("Error toggling favorite: \(error)")
            self.errorMessage = "Failed to update favorites"
        }
    }
    
    func confirmRemoveFavorite() {
        guard let product = productToRemove else { return }
        do {
            try removeFavoriteUseCase.execute(productId: product.id)
            self.objectWillChange.send() // Trigger UI update
        } catch {
            print("Error removing favorite: \(error)")
            self.errorMessage = "Failed to remove favorite"
        }
    }
}
