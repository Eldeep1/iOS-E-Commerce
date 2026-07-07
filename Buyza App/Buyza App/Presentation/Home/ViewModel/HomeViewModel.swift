//
//  HomeViewModel.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 29/06/2026.
//

import Foundation

@MainActor
class HomeViewModel : ObservableObject {
    @Published var categories : [Collection] = []
    @Published var brands : [Collection] = []
    @Published var products : [Product] = []

    @Published var showRemoveAlert: Bool = false
    @Published var productToRemove: Product?
    @Published var showGuestAlert: Bool = false

    @Published var isCategoriesLoading : Bool = false
    @Published var isBrandsLoading : Bool = false
    @Published var isProductsLoading : Bool = false
    @Published var errorMessage : String?

    var isGuest: Bool = false

    private let getCategoriesUseCase: GetCategoriesUseCaseProtocol
    private let getBrandsUseCase: GetBrandsUseCaseProtocol
    private let getFeaturedProductsUseCase: GetFeaturedProductsUseCaseProtocol

    init(
        isGuest: Bool = false,
        getCategoriesUseCase: GetCategoriesUseCaseProtocol? = nil,
        getBrandsUseCase: GetBrandsUseCaseProtocol? = nil,
        getFeaturedProductsUseCase: GetFeaturedProductsUseCaseProtocol? = nil
    ) {
        self.isGuest = isGuest

        let defaultRepo = HomeRepoImp(
            remoteDataSource: HomeRemoteDataSource(),
            localDataSource: ProductLocalDataSource()
        )

        self.getCategoriesUseCase = getCategoriesUseCase ?? GetCategoriesUseCase(repository: defaultRepo)
        self.getBrandsUseCase = getBrandsUseCase ?? GetBrandsUseCase(repository: defaultRepo)
        self.getFeaturedProductsUseCase = getFeaturedProductsUseCase ?? GetFeaturedProductsUseCase(repository: defaultRepo)

        fetchCategories()
        fetchBrands()
        fetchRecommendedProducts()
    }

    func fetchCategories() {
        Task {
            self.isCategoriesLoading = true
            do {
                self.categories = try await getCategoriesUseCase.execute()
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error fetching categories: \(error)")
            }
            self.isCategoriesLoading = false
        }
    }

    func fetchBrands() {
        Task {
            self.isBrandsLoading = true
            do {
                self.brands = try await getBrandsUseCase.execute()
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error fetching brands: \(error)")
            }
            self.isBrandsLoading = false
        }
    }

    func fetchRecommendedProducts() {
        Task {
            self.isProductsLoading = true
            do {
                self.products = try await getFeaturedProductsUseCase.execute()
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error fetching products: \(error)")
            }
            self.isProductsLoading = false
        }
    }

    func toggleFavorite(product: Product, favoritesStore: FavoritesStore) {
        if isGuest {
            showGuestAlert = true
            return
        }

        if favoritesStore.isFavorite(productId: product.id) {
            productToRemove = product
            showRemoveAlert = true
        } else {
            do {
                try favoritesStore.add(product: product)
            } catch {
                print("Error toggling favorite: \(error)")
                errorMessage = L10n.failedUpdateFavorites.text(for: AppLanguage.stored)
            }
        }
    }

    func confirmRemoveFavorite(favoritesStore: FavoritesStore) {
        guard let product = productToRemove else { return }
        do {
            try favoritesStore.remove(productId: product.id)
        } catch {
            print("Error removing favorite: \(error)")
            errorMessage = L10n.failedRemoveFavorites.text(for: AppLanguage.stored)
        }
    }
}
