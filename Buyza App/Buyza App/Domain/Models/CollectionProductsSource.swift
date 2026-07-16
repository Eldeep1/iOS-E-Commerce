//
//  CollectionProductsSource.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 02/07/2026.
//

import Foundation

enum CollectionProductsSource {
    case all
    case category(collectionId: Int)
    case brand(vendor: String)
}
