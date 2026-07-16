//
//  LoginViewHeader.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//

import SwiftUI

struct LoginViewHeader: View {
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        Spacer().frame(height: 40)
        
        VStack(spacing: 8) {
            Text(localization.text(.welcomeBack))
                .font(.system(size: 34, weight: .bold, design: .default))
                .foregroundColor(.black)
            
            Text(localization.text(.signInSubtitle))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
