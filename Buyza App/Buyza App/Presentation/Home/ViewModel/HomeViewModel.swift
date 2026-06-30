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
    
    // will add a Published variable for the real product model
    @Published var fakeProducts : FakeProductResponse?
    
    init() {
        // will inject it with the usecase instance
        
        fetchCategories()
        fetchBrands()
        fetchRecommendedProducts()
    }
    
    func fetchCategories() {
        // will fetch the categories here
        
        let dummyItem1 = Collection(
            id: 101,
            title: "MEN",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/custom_collections_1.jpg?v=1782058628")
        )
        
        let dummyItem2 = Collection(
            id: 102,
            title: "MEN",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/custom_collections_1.jpg?v=1782058628")
        )
        
        let dummyItem3 = Collection(
            id: 103,
            title: "MEN",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/custom_collections_1.jpg?v=1782058628")
        )
        
        
        let dummyItem4 = Collection(
            id: 104,
            title: "MEN",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/custom_collections_1.jpg?v=1782058628")
        )
        
        let dummyItem5 = Collection(
            id: 105,
            title: "MEN",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/custom_collections_1.jpg?v=1782058628")
        )
        
        categories = CategoryResponse(custom_collections: [dummyItem1, dummyItem2, dummyItem3, dummyItem4, dummyItem5])
    }
    
    func fetchBrands() {
        // will fetch the brands here
        
        let dummyItem1 = Collection(
            id: 101,
            title: "ADIDAS",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
        )
        
        let dummyItem2 = Collection(
            id: 102,
            title: "ADIDAS",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
        )
        
        let dummyItem3 = Collection(
            id: 103,
            title: "ADIDAS",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
        )
        
        
        let dummyItem4 = Collection(
            id: 104,
            title: "ADIDAS",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
        )
        
        let dummyItem5 = Collection(
            id: 105,
            title: "ADIDAS",
            image: NetworkImage(src: "https://cdn.shopify.com/s/files/1/0790/8907/4373/collections/smart_collections_2.jpg?v=1782058592")
        )
        
        brands = BrandResponse(smart_collections: [dummyItem1, dummyItem2, dummyItem3, dummyItem4, dummyItem5])
    }
    
    func fetchRecommendedProducts() {
        // will fetch here some of the products with a limit to show them as the recommended products
        
        let fakeProduct1 = FakeProduct(id: 1, title: "Sample Product Sample Product Sample Product", price: 29.99, image: "dummy-product")
        
        let fakeProduct2 = FakeProduct(id: 2, title: "Sample Product Sample Product Sample Product", price: 29.99, image: "dummy-product")
        
        let fakeProduct3 = FakeProduct(id: 3, title: "Sample Product Sample Product Sample Product", price: 29.99, image: "dummy-product")
        
        let fakeProduct4 = FakeProduct(id: 4, title: "Sample Product Sample Product Sample Product", price: 29.99, image: "dummy-product")
        
        let fakeProduct5 = FakeProduct(id: 5, title: "Sample Product Sample Product Sample Product", price: 29.99, image: "dummy-product")
        
        let fakeProduct6 = FakeProduct(id: 6, title: "Sample Product Sample Product Sample Product", price: 29.99, image: "dummy-product")
        
        fakeProducts = FakeProductResponse(products: [fakeProduct1, fakeProduct2, fakeProduct3, fakeProduct4, fakeProduct5, fakeProduct6])
    }
    
    func isFavorite(productID: Int) -> Bool {
        // will call here the function from the usecase
        
        return true
    }
}
