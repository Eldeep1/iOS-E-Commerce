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
    private let saveFavoriteUseCase: SaveFavoriteUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    private let checkIsFavoriteUseCase: CheckIsFavoriteUseCaseProtocol
    
    init(
        isGuest: Bool = false,
        getCategoriesUseCase: GetCategoriesUseCaseProtocol? = nil,
        getBrandsUseCase: GetBrandsUseCaseProtocol? = nil,
        getFeaturedProductsUseCase: GetFeaturedProductsUseCaseProtocol? = nil,
        saveFavoriteUseCase: SaveFavoriteUseCaseProtocol? = nil,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol? = nil,
        checkIsFavoriteUseCase: CheckIsFavoriteUseCaseProtocol? = nil
    ) {
        self.isGuest = isGuest
        
        let defaultRepo = HomeRepoImp(
            remoteDataSource: HomeRemoteDataSource(),
            localDataSource: ProductLocalDataSource()
        )
        
        self.getCategoriesUseCase = getCategoriesUseCase ?? GetCategoriesUseCase(repository: defaultRepo)
        self.getBrandsUseCase = getBrandsUseCase ?? GetBrandsUseCase(repository: defaultRepo)
        self.getFeaturedProductsUseCase = getFeaturedProductsUseCase ?? GetFeaturedProductsUseCase(repository: defaultRepo)
        self.saveFavoriteUseCase = saveFavoriteUseCase ?? SaveFavoriteUseCase(repository: defaultRepo)
        self.removeFavoriteUseCase = removeFavoriteUseCase ?? RemoveFavoriteUseCase(repository: defaultRepo)
        self.checkIsFavoriteUseCase = checkIsFavoriteUseCase ?? CheckIsFavoriteUseCase(repository: defaultRepo)
        
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
    
    // MARK: - Favorites
    
    func isFavorite(productID: Int64) -> Bool {
        if isGuest { return false }
        return (try? checkIsFavoriteUseCase.execute(productId: productID)) ?? false
    }
    
    func toggleFavorite(product: Product) {
        if isGuest {
            showGuestAlert = true
            return
        }
        
        do {
            let isFav = try checkIsFavoriteUseCase.execute(productId: product.id)
            if isFav {
                self.productToRemove = product
                self.showRemoveAlert = true
            } else {
                try saveFavoriteUseCase.execute(product: product)
                self.objectWillChange.send()
            }
        } catch {
            print("Error toggling favorite: \(error)")
            self.errorMessage = L10n.failedUpdateFavorites.text(for: AppLanguage.stored)
        }
    }
    
    func confirmRemoveFavorite() {
        guard let product = productToRemove else { return }
        do {
            try removeFavoriteUseCase.execute(productId: product.id)
            self.objectWillChange.send()
        } catch {
            print("Error removing favorite: \(error)")
            self.errorMessage = L10n.failedRemoveFavorites.text(for: AppLanguage.stored)
        }
    }
}
