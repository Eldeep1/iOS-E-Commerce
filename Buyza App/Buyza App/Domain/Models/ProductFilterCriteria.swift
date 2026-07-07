//
//  ProductFilterCriteria.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 03/07/2026.
//

import Foundation

struct ProductFilterCriteria: Equatable {
    var searchText: String = ""
    var productType: String?
    var vendor: String?
    var publishedStatus: ProductPublishedStatus = .any
    var status: ProductStatusFilter?
    var minPrice: Decimal?
    var maxPrice: Decimal?
    var sort: ProductSortOption = .recommended

    var hasActiveFilters: Bool {
        productType != nil
            || vendor != nil
            || minPrice != nil
            || maxPrice != nil
            || sort != .recommended
            || !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

enum ProductPublishedStatus: String, CaseIterable, Identifiable {
    case any
    case published
    case unpublished

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .any: return "Any"
        case .published: return "Published"
        case .unpublished: return "Unpublished"
        }
    }

    var apiValue: String? {
        self == .any ? nil : rawValue
    }
}

enum ProductStatusFilter: String, CaseIterable, Identifiable {
    case active
    case archived
    case draft

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}

enum ProductSortOption: String, CaseIterable, Identifiable {
    case recommended
    case priceLowToHigh
    case priceHighToLow
    case titleAZ

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .recommended: return "Recommended"
        case .priceLowToHigh: return "Price: Low to High"
        case .priceHighToLow: return "Price: High to Low"
        case .titleAZ: return "Name: A–Z"
        }
    }
}
