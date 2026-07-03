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

    let showsVendorFilter = true
    let filterLabel = "All Products"

    private let filterUseCase: FilterProductsUseCaseProtocol
    private var baselineProductTypes: [String] = []
    private var baselineVendors: [String] = []

    var searchPlaceholder: String {
        "Search products"
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
        filterUseCase: FilterProductsUseCaseProtocol = FilterProductsUseCase(
            repository: HomeRepoImp(
                remoteDataSource: HomeRemoteDataSource()
            )
        )
    ) {
        self.searchText = initialSearchText
        self.filterUseCase = filterUseCase
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

    func isFavorite(productID: Int64) -> Bool {
        false
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
