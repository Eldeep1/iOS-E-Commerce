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
