//
//  AppLanguage.swift
//  Buyza App
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case arabic = "ar"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        }
    }

    var localeIdentifier: String {
        switch self {
        case .english: return "en"
        case .arabic: return "ar"
        }
    }

    var isRTL: Bool {
        self == .arabic
    }
}
