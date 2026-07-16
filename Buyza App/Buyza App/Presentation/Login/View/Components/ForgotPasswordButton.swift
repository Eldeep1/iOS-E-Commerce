//
//  ForgotPasswordButton.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//


import SwiftUI

struct ForgotPasswordButton: View {
    @EnvironmentObject private var localization: LocalizationManager
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(localization.text(.forgotPassword))
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.blue)
        }
    }
}
