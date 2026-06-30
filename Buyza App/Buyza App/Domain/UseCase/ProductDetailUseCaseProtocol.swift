//
//  ProductDetailUseCaseProtocol.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

protocol ProductDetailUseCaseProtocol {
    func execute(product: Product) -> ProductDetailState
}

struct ProductDetailState {
    let product: Product
    let formattedPrice: String
    let selectedSizeIndex: Int
    let selectedColorIndex: Int
    let informationSections: [ProductInformationSection]
}

struct ProductInformationSection: Identifiable, Hashable {
    let id: String
    let title: String
    let content: String
}
