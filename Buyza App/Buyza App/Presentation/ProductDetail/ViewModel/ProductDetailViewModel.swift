//
//  ProductDetailViewModel.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

@MainActor
final class ProductDetailViewModel: ObservableObject {

    @Published private(set) var product: Product
    @Published var selectedSizeIndex: Int
    @Published var selectedColorIndex: Int
    @Published var currentImageIndex: Int = 0
    @Published var expandedSectionIDs: Set<String>
    @Published var isFavorite: Bool = false

    let formattedPrice: String
    let informationSections: [ProductInformationSection]

    init(product: Product, useCase: ProductDetailUseCaseProtocol = ProductDetailUseCase()) {
        let state = useCase.execute(product: product)
        self.product = state.product
        self.formattedPrice = state.formattedPrice
        self.selectedSizeIndex = state.selectedSizeIndex
        self.selectedColorIndex = state.selectedColorIndex
        self.informationSections = state.informationSections
        self.expandedSectionIDs = Set(state.informationSections.prefix(1).map(\.id))
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
    }

    func buyNow() {
    }
}
