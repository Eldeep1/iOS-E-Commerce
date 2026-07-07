//
//  LocalizationManager.swift
//  Buyza App
//

import SwiftUI

final class LocalizationManager: ObservableObject {
    private static let storageKey = "app_language"

    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: Self.storageKey)
        }
    }

    var layoutDirection: LayoutDirection {
        currentLanguage.isRTL ? .rightToLeft : .leftToRight
    }

    init() {
        if let saved = UserDefaults.standard.string(forKey: Self.storageKey),
           let language = AppLanguage(rawValue: saved) {
            currentLanguage = language
        } else {
            currentLanguage = .english
        }
    }

    func text(_ key: L10n) -> String {
        key.text(for: currentLanguage)
    }

    func format(_ key: L10n, _ arguments: CVarArg...) -> String {
        let template = text(key)
        guard !arguments.isEmpty else { return template }
        return String(format: template, arguments: arguments)
    }
}

extension AppLanguage {
    static var stored: AppLanguage {
        if let saved = UserDefaults.standard.string(forKey: "app_language"),
           let language = AppLanguage(rawValue: saved) {
            return language
        }
        return .english
    }
}

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favoriteIds: Set<Int64> = []

    private let saveFavoriteUseCase: SaveFavoriteUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    private let getFavoriteProductsUseCase: GetFavoriteProductsUseCaseProtocol

    init(
        saveFavoriteUseCase: SaveFavoriteUseCaseProtocol? = nil,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol? = nil,
        getFavoriteProductsUseCase: GetFavoriteProductsUseCaseProtocol? = nil
    ) {
        let repo = HomeRepoImp(
            remoteDataSource: HomeRemoteDataSource(),
            localDataSource: ProductLocalDataSource()
        )
        self.saveFavoriteUseCase = saveFavoriteUseCase ?? SaveFavoriteUseCase(repository: repo)
        self.removeFavoriteUseCase = removeFavoriteUseCase ?? RemoveFavoriteUseCase(repository: repo)
        self.getFavoriteProductsUseCase = getFavoriteProductsUseCase ?? GetFavoriteProductsUseCase(
            repository: FavoritesRepoImp(localDataSource: ProductLocalDataSource())
        )
        reload()
    }

    func reload() {
        favoriteIds = Set((try? getFavoriteProductsUseCase.execute().map(\.id)) ?? [])
    }

    func isFavorite(productId: Int64) -> Bool {
        favoriteIds.contains(productId)
    }

    func add(product: Product) throws {
        try saveFavoriteUseCase.execute(product: product)
        favoriteIds.insert(product.id)
    }

    func remove(productId: Int64) throws {
        try removeFavoriteUseCase.execute(productId: productId)
        favoriteIds.remove(productId)
    }
}
