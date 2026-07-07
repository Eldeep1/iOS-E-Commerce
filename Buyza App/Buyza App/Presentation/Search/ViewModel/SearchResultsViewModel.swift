//
//  SearchResultsViewModel.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 02/07/2026.
//

import Foundation

@MainActor
final class SearchResultsViewModel: ObservableObject {
    @Published private(set) var fetchedProducts: [Product] = []
    @Published var searchText: String
    @Published var filterCriteria = ProductFilterCriteria()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFilterSheetPresented = false
    @Published var showRemoveAlert = false
    @Published var productToRemove: Product?
    @Published var showGuestAlert = false
    var isGuest = false

    let showsVendorFilter = true

    var filterLabel: String {
        L10n.allProducts.text(for: AppLanguage.stored)
    }

    private let filterUseCase: FilterProductsUseCaseProtocol
    private var baselineProductTypes: [String] = []
    private var baselineVendors: [String] = []

    var searchPlaceholder: String {
        L10n.searchProducts.text(for: AppLanguage.stored)
    }

    var availableProductTypes: [String] {
        let current = fetchedProducts.map(\.product_type)
        return Array(Set(baselineProductTypes + current)).sorted()
    }

    var availableVendors: [String] {
        let current = fetchedProducts.map(\.vendor)
        return Array(Set(baselineVendors + current)).sorted()
    }

    var displayedProducts: [Product] {
        filterUseCase.applyLocalFilters(
            products: fetchedProducts,
            criteria: mergedCriteria
        )
    }

    var hasActiveFilters: Bool {
        mergedCriteria.hasActiveFilters
    }

    init(
        initialSearchText: String = "",
        filterUseCase: FilterProductsUseCaseProtocol? = nil
    ) {
        let defaultRepo = HomeRepoImp(
            remoteDataSource: HomeRemoteDataSource(),
            localDataSource: ProductLocalDataSource()
        )

        self.searchText = initialSearchText
        self.filterUseCase = filterUseCase ?? FilterProductsUseCase(repository: defaultRepo)
        fetchProducts()
    }

    func fetchProducts() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                fetchedProducts = try await filterUseCase.fetchProducts(
                    source: .all,
                    criteria: apiCriteria
                )
                updateBaselineOptionsIfNeeded()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func applyFilters() {
        fetchProducts()
    }

    func resetFilters() {
        searchText = ""
        filterCriteria = ProductFilterCriteria()
        fetchProducts()
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

    private var mergedCriteria: ProductFilterCriteria {
        var criteria = filterCriteria
        criteria.searchText = searchText
        return criteria
    }

    private var apiCriteria: ProductFilterCriteria {
        var criteria = filterCriteria
        criteria.searchText = ""
        criteria.minPrice = nil
        criteria.maxPrice = nil
        criteria.sort = .recommended
        return criteria
    }

    private func updateBaselineOptionsIfNeeded() {
        if baselineProductTypes.isEmpty {
            baselineProductTypes = Array(Set(fetchedProducts.map(\.product_type))).sorted()
        }
        if baselineVendors.isEmpty {
            baselineVendors = Array(Set(fetchedProducts.map(\.vendor))).sorted()
        }
    }
}
