//
//  ProductSizeSelector.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import SwiftUI

struct ProductSizeSelector: View {
    @EnvironmentObject private var localization: LocalizationManager
    let sizes: [String]
    let selectedIndex: Int
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.text(.selectSize))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                ForEach(Array(sizes.enumerated()), id: \.offset) { index, size in
                    Button {
                        onSelect(index)
                    } label: {
                        Text(size.uppercased())
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedIndex == index ? Color(.systemGray5) : Color(.systemGray6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: selectedIndex == index ? 0 : 1)
                            )
                    }
                }
            }
        }
    }
}
