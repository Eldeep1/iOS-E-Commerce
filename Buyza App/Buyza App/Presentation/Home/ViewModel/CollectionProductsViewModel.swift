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
    @Published var isLoading = false
    @Published var errorMessage: String?

    let collectionTitle: String

    private let source: CollectionProductsSource
    private let homeUseCase: HomeUseCaseProtocol

    init(
        collectionTitle: String,
        source: CollectionProductsSource,
        homeUseCase: HomeUseCaseProtocol = HomeUseCase(
            homeRepo: HomeRepoImp(
                remoteDataSource: HomeRemoteDataSource()
            )
        )
    ) {
        self.collectionTitle = collectionTitle
        self.source = source
        self.homeUseCase = homeUseCase
        fetchProducts()
    }

    func fetchProducts() {
        Task {
            isLoading = true
            do {
                switch source {
                case .category(let collectionId):
                    products = try await homeUseCase.getProducts(collectionId: collectionId)
                case .brand(let vendor):
                    products = try await homeUseCase.getProductsByVendor(vendor: vendor)
                }
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
