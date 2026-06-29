//
//  HomeViewModel.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 29/06/2026.
//

import Foundation


class HomeViewModel : ObservableObject {
    @Published var categories : CategoryResponse?
    @Published var brands : BrandResponse?
    // also will add a Published variable for the products
    
    init() {
        // will inject it with the usecase instance
    }
    
    func fetchCategories() {
        // will fetch the categories here
    }
    
    func fetchBrands() {
        // will fetch the brands here
    }
    
    func fetchRecommendedProducrts() {
        // will fetch here some of the products with a limit to show them as the recommended products
    }
}
