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
    @Published var isLoading : Bool = false
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
            do {
                self.categories = try await homeUseCase.getCategories()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchBrands() {
        Task { @MainActor in
            do {
                self.brands = try await homeUseCase.getBrands()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchRecommendedProducts() {
        Task { @MainActor in
            self.isLoading = true
            do {
                self.products = try await homeUseCase.getRecommendedProducts()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func isFavorite(productID: Int) -> Bool {
        // will call here the function from the usecase
        
        return true
    }
}

