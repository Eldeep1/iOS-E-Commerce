//
//  PaymentMethodType+Localization.swift
//  Buyza App
//

import Foundation

extension PaymentMethodType {
    func localizedName(for language: AppLanguage) -> String {
        switch self {
        case .creditCard:
            return L10n.creditDebitCard.text(for: language)
        case .cashOnDelivery:
            return L10n.cashOnDelivery.text(for: language)
        }
    }
}
