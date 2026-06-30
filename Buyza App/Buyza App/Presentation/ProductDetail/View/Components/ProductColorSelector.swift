//
//  ProductColorSelector.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import SwiftUI

struct ProductColorSelector: View {
    let colors: [String]
    let selectedIndex: Int
    let selectedColorLabel: String?
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("COLOR: \(selectedColorLabel ?? colors[safe: selectedIndex]?.uppercased() ?? "")")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            HStack(spacing: 16) {
                ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                    Button {
                        onSelect(index)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color(hex: hexCode(for: color)))
                                .frame(width: 36, height: 36)

                            if selectedIndex == index {
                                Circle()
                                    .stroke(Color.primary, lineWidth: 2)
                                    .frame(width: 44, height: 44)

                                Circle()
                                    .stroke(Color(.systemBackground), lineWidth: 2)
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                }
            }
        }
    }

    private func hexCode(for colorName: String) -> String {
        Self.colorHexMap[colorName.lowercased()] ?? "808080"
    }

    private static let colorHexMap: [String: String] = [
        "black": "1A1A1A",
        "white": "F5F5F5",
        "red": "D32F2F",
        "blue": "1976D2",
        "green": "388E3C",
        "gray": "9E9E9E",
        "grey": "9E9E9E",
        "navy": "1B2A4E",
        "pink": "F48FB1",
        "beige": "D7C4A5",
        "brown": "795548"
    ]
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
