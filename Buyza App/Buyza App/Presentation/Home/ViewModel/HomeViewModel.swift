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
    @Published var favoriteIDs: Set<Int64> = []
    
    @Published var isCategoriesLoading : Bool = false
    @Published var isBrandsLoading : Bool = false
    @Published var isProductsLoading : Bool = false
    @Published var errorMessage : String?
    
    private let getCategoriesUseCase: GetCategoriesUseCaseProtocol
    private let getBrandsUseCase: GetBrandsUseCaseProtocol
    private let getFeaturedProductsUseCase: GetFeaturedProductsUseCaseProtocol
    private let saveFavoriteUseCase: SaveFavoriteUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    
    init(
        getCategoriesUseCase: GetCategoriesUseCaseProtocol? = nil,
        getBrandsUseCase: GetBrandsUseCaseProtocol? = nil,
        getFeaturedProductsUseCase: GetFeaturedProductsUseCaseProtocol? = nil,
        saveFavoriteUseCase: SaveFavoriteUseCaseProtocol? = nil,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol? = nil
    ) {
        let defaultRepo = HomeRepoImp(
            remoteDataSource: HomeRemoteDataSource(),
            localDataSource: ProductLocalDataSource()
        )
        
        self.getCategoriesUseCase = getCategoriesUseCase ?? GetCategoriesUseCase(repository: defaultRepo)
        self.getBrandsUseCase = getBrandsUseCase ?? GetBrandsUseCase(repository: defaultRepo)
        self.getFeaturedProductsUseCase = getFeaturedProductsUseCase ?? GetFeaturedProductsUseCase(repository: defaultRepo)
        self.saveFavoriteUseCase = saveFavoriteUseCase ?? SaveFavoriteUseCase(repository: defaultRepo)
        self.removeFavoriteUseCase = removeFavoriteUseCase ?? RemoveFavoriteUseCase(repository: defaultRepo)
        
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
