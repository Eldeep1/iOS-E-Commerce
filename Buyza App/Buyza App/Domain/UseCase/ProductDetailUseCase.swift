//
//  ProductDetailUseCase.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

struct ProductDetailUseCase: ProductDetailUseCaseProtocol {

    func execute(product: Product) -> ProductDetailState {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        let formattedPrice = formatter.string(from: product.price as NSDecimalNumber) ?? "\(product.price)"

        var sections: [ProductInformationSection] = []
        if !product.descriptionText.isEmpty {
            sections.append(
                ProductInformationSection(
                    id: "description",
                    title: "DESCRIPTION",
                    content: product.descriptionText
                )
            )
        }

        return ProductDetailState(
            product: product,
            formattedPrice: formattedPrice,
            selectedSizeIndex: 0,
            selectedColorIndex: 0,
            informationSections: sections
        )
    }
}
