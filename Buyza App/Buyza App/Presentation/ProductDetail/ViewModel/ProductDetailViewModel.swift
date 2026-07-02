//
//  ProductDetailViewModel.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation
import SwiftUI

@MainActor
final class ProductDetailViewModel: ObservableObject {

    @Published private(set) var product: Product
    @Published var selectedSizeIndex: Int
    @Published var selectedColorIndex: Int
    @Published var currentImageIndex: Int = 0
    @Published var expandedSectionIDs: Set<String>
    @Published var isFavorite: Bool = false
    
    @AppStorage("shopify_cart_id") private var storedCartID: String = ""
    @Published var isAddToCartLoading = false
    @Published var addToCartSuccess = false
    @Published var navigateToCart = false
    @Published var addToCartError: String? = nil

    let formattedPrice: String
    let informationSections: [ProductInformationSection]
    private let addToCartUseCase: AddToCartUseCaseProtocol

    init(
        product: Product, 
        useCase: ProductDetailUseCaseProtocol = ProductDetailUseCase(),
        addToCartUseCase: AddToCartUseCaseProtocol = AddToCartUseCase(repository: CartRepositoryImp())
    ) {
        let state = useCase.execute(product: product)
        self.product = state.product
        self.formattedPrice = state.formattedPrice
        self.selectedSizeIndex = state.selectedSizeIndex
        self.selectedColorIndex = state.selectedColorIndex
        self.informationSections = state.informationSections
        self.expandedSectionIDs = Set(state.informationSections.prefix(1).map(\.id))
        self.addToCartUseCase = addToCartUseCase
    }

    var selectedColorLabel: String? {
        guard product.colorValues.indices.contains(selectedColorIndex) else { return nil }
        return product.colorValues[selectedColorIndex].uppercased()
    }

    var showsSizeSelector: Bool {
        !product.sizeValues.isEmpty
    }

    var showsColorSelector: Bool {
        !product.colorValues.isEmpty
    }

    func selectSize(at index: Int) {
        guard product.sizeValues.indices.contains(index) else { return }
        selectedSizeIndex = index
    }

    func selectColor(at index: Int) {
        guard product.colorValues.indices.contains(index) else { return }
        selectedColorIndex = index
    }

    func toggleSection(_ id: String) {
        if expandedSectionIDs.contains(id) {
            expandedSectionIDs.remove(id)
        } else {
            expandedSectionIDs.insert(id)
        }
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }

    func addToCart() {
        guard let variant = product.variants.first else { return }
        // Storefront API uses gid://shopify/ProductVariant/...
        let variantID = "gid://shopify/ProductVariant/\(variant.id)"
        
        isAddToCartLoading = true
        Task {
            do {
                let result = try await addToCartUseCase.execute(
                    cartID: storedCartID.isEmpty ? nil : storedCartID,
                    variantID: variantID,
                    quantity: 1
                )
                storedCartID = result.cartID
                addToCartSuccess = true
            } catch {
                addToCartError = error.localizedDescription
            }
            isAddToCartLoading = false
        }
    }

    func buyNow() {
        guard let variant = product.variants.first else { return }
        let variantID = "gid://shopify/ProductVariant/\(variant.id)"
        
        isAddToCartLoading = true
        Task {
            do {
                let result = try await addToCartUseCase.execute(
                    cartID: storedCartID.isEmpty ? nil : storedCartID,
                    variantID: variantID,
                    quantity: 1
                )
                storedCartID = result.cartID
                navigateToCart = true
            } catch {
                addToCartError = error.localizedDescription
            }
            isAddToCartLoading = false
        }
    }
}
