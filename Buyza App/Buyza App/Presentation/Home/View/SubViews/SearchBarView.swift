//
//  SearchBarView.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 03/07/2026.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String?
    var onSubmit: (() -> Void)?
    var onIconTap: (() -> Void)?

    @EnvironmentObject private var localization: LocalizationManager

    init(
        text: Binding<String>,
        placeholder: String? = nil,
        onSubmit: (() -> Void)? = nil,
        onIconTap: (() -> Void)? = nil
    ) {
        _text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
        self.onIconTap = onIconTap
    }

    private var resolvedPlaceholder: String {
        placeholder ?? localization.text(.searchPlaceholder)
    }

    var body: some View {
        HStack {
            Group {
                if let onIconTap {
                    Button(action: onIconTap) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                } else {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }

            TextField(resolvedPlaceholder, text: $text)
                .foregroundColor(.primary)
                .submitLabel(onSubmit == nil ? .done : .search)
                .onSubmit {
                    onSubmit?()
                }

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

#Preview {
    SearchBarView(text: .constant("adidas"), placeholder: "Search in ADIDAS")
        .environmentObject(LocalizationManager())
}
