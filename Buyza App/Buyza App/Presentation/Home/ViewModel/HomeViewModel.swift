//
//  HomeViewModel.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 29/06/2026.
//

import Foundation


class HomeViewModel : ObservableObject {
    @Published var categories : [Collection] = []
    @Published var brands : [Collection] = []
    @Published var products : [Product] = []
    @Published var isCategoriesLoading : Bool = false
    @Published var isBrandsLoading : Bool = false
    @Published var isProductsLoading : Bool = false
    @Published var errorMessage : String?
    
    private let homeUseCase : HomeUseCaseProtocol
    
    init(homeUseCase: HomeUseCaseProtocol = HomeUseCase(
        homeRepo: HomeRepoImp(
            remoteDataSource: HomeRemoteDataSource()
        )
    )) {
        self.homeUseCase = homeUseCase
        
        fetchCategories()
        fetchBrands()
        fetchRecommendedProducts()
    }
    
    func fetchCategories() {
        Task { @MainActor in
            self.isCategoriesLoading = true
            do {
                self.categories = try await homeUseCase.getCategories()
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error fetching categories: \(error)")
            }
            self.isCategoriesLoading = false
        }
    }
    
    func fetchBrands() {
        Task { @MainActor in
            self.isBrandsLoading = true
            do {
                self.brands = try await homeUseCase.getBrands()
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error fetching brands: \(error)")
            }
            self.isBrandsLoading = false
        }
    }
    
    func fetchRecommendedProducts() {
        Task { @MainActor in
            self.isProductsLoading = true
            do {
                self.products = try await homeUseCase.getRecommendedProducts()
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error fetching products: \(error)")
            }
            self.isProductsLoading = false
        }
    }
    
    func isFavorite(productID: Int) -> Bool {
        // will call here the function from the usecase
        
        return true
    }
}

