//
//  CollectionProductsViewModel.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

@MainActor
final class CollectionProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    let collectionTitle: String

    private let collectionId: Int
    private let homeUseCase: HomeUseCaseProtocol

    init(
        collectionId: Int,
        collectionTitle: String,
        homeUseCase: HomeUseCaseProtocol = HomeUseCase(
            homeRepo: HomeRepoImp(
                remoteDataSource: HomeRemoteDataSource()
            )
        )
    ) {
        self.collectionId = collectionId
        self.collectionTitle = collectionTitle
        self.homeUseCase = homeUseCase
        fetchProducts()
    }

    func fetchProducts() {
        Task {
            isLoading = true
            do {
                products = try await homeUseCase.getProducts(collectionId: collectionId)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func isFavorite(productID: Int64) -> Bool {
        false
    }
}
