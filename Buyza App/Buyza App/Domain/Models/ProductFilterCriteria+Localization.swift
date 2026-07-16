//
//  ProductFilterCriteria+Localization.swift
//  Buyza App
//

import Foundation

extension ProductPublishedStatus {
    func localizedName(for language: AppLanguage) -> String {
        switch self {
        case .any: return L10n.publishedAny.text(for: language)
        case .published: return L10n.publishedPublished.text(for: language)
        case .unpublished: return L10n.publishedUnpublished.text(for: language)
        }
    }
}

extension ProductStatusFilter {
    func localizedName(for language: AppLanguage) -> String {
        switch self {
        case .active: return L10n.statusActive.text(for: language)
        case .archived: return L10n.statusArchived.text(for: language)
        case .draft: return L10n.statusDraft.text(for: language)
        }
    }
}

extension ProductSortOption {
    func localizedName(for language: AppLanguage) -> String {
        switch self {
        case .recommended: return L10n.recommended.text(for: language)
        case .priceLowToHigh: return L10n.priceLowToHigh.text(for: language)
        case .priceHighToLow: return L10n.priceHighToLow.text(for: language)
        case .titleAZ: return L10n.titleAZ.text(for: language)
        }
    }
}
