//
//  LoginHeader.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI

struct LoginHeader: View {
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        VStack(spacing: 8) {
            Text(localization.text(.welcomeBack))
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)
            
            Text(localization.text(.signInSubtitle))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
