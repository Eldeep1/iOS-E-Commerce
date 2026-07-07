//
//  CollectionProductsViewModel.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 02/07/2026.
//

import Foundation

@MainActor
final class CollectionProductsViewModel: ObservableObject {
    @Published private(set) var fetchedProducts: [Product] = []
    @Published var searchText: String = ""
    @Published var filterCriteria = ProductFilterCriteria()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFilterSheetPresented = false
    @Published var showRemoveAlert = false
    @Published var productToRemove: Product?
    @Published var showGuestAlert = false
    
    var isGuest: Bool = false

    let collectionTitle: String
    let showsVendorFilter: Bool

    private let source: CollectionProductsSource
    private let filterUseCase: FilterProductsUseCaseProtocol
    private var baselineProductTypes: [String] = []
    private var baselineVendors: [String] = []

    var searchPlaceholder: String {
        String(format: L10n.searchIn.text(for: AppLanguage.stored), collectionTitle)
    }

    var filterLabel: String {
        Self.makeFilterLabel(title: collectionTitle, source: source)
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
        collectionTitle: String,
        source: CollectionProductsSource,
        filterUseCase: FilterProductsUseCaseProtocol? = nil
    ) {
        let defaultRepo = HomeRepoImp(
            remoteDataSource: HomeRemoteDataSource(),
            localDataSource: ProductLocalDataSource()
        )

        self.collectionTitle = collectionTitle
        self.source = source
        self.filterUseCase = filterUseCase ?? FilterProductsUseCase(repository: defaultRepo)
        self.showsVendorFilter = {
            if case .category = source { return true }
            if case .all = source { return true }
            return false
        }()
        fetchProducts()
    }

    func fetchProducts() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                fetchedProducts = try await filterUseCase.fetchProducts(
                    source: source,
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

    private static func makeFilterLabel(
        title: String,
        source: CollectionProductsSource
    ) -> String {
        let language = AppLanguage.stored
        switch source {
        case .all:
            return L10n.allProducts.text(for: language)
        case .category:
            return String(format: L10n.categoryFilter.text(for: language), title)
        case .brand(let vendor):
            return String(format: L10n.brandFilter.text(for: language), vendor)
        }
    }
}
