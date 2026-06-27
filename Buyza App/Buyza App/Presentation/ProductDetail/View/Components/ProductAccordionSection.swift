//
//  ProductAccordionSection.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import SwiftUI

struct ProductAccordionSection: View {
    let section: ProductInformationSection
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    Text(section.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 18)
            }

            if isExpanded {
                Text(section.content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 18)
            }

            Divider()
        }
    }
}
