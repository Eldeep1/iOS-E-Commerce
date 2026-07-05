//
//  ProductFilterSheet.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 03/07/2026.
//

import SwiftUI

struct ProductFilterSheet: View {
    @Binding var criteria: ProductFilterCriteria
    let productTypes: [String]
    let vendors: [String]
    let showsVendorFilter: Bool
    var onApply: () -> Void
    var onReset: () -> Void

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localization: LocalizationManager

    @State private var minPriceText: String = ""
    @State private var maxPriceText: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(localization.text(.productType)) {
                    Picker(localization.text(.productType), selection: productTypeBinding) {
                        Text(localization.text(.allTypes)).tag("")
                        ForEach(productTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }

                if showsVendorFilter {
                    Section(localization.text(.brandVendor)) {
                        Picker(localization.text(.brandVendor), selection: vendorBinding) {
                            Text(localization.text(.allBrands)).tag("")
                            ForEach(vendors, id: \.self) { vendor in
                                Text(vendor).tag(vendor)
                            }
                        }
                    }
                }

                Section(localization.text(.priceRange)) {
                    TextField(localization.text(.minPrice), text: $minPriceText)
                        .keyboardType(.decimalPad)
                    TextField(localization.text(.maxPrice), text: $maxPriceText)
                        .keyboardType(.decimalPad)
                }

                Section(localization.text(.availability)) {
                    Picker(localization.text(.published), selection: $criteria.publishedStatus) {
                        ForEach(ProductPublishedStatus.allCases) { status in
                            Text(status.localizedName(for: localization.currentLanguage)).tag(status)
                        }
                    }

                    Picker(localization.text(.status), selection: statusBinding) {
                        Text(localization.text(.any)).tag("")
                        ForEach(ProductStatusFilter.allCases) { status in
                            Text(status.localizedName(for: localization.currentLanguage)).tag(status.rawValue)
                        }
                    }
                }

                Section(localization.text(.sortBy)) {
                    Picker(localization.text(.sortBy), selection: $criteria.sort) {
                        ForEach(ProductSortOption.allCases) { option in
                            Text(option.localizedName(for: localization.currentLanguage)).tag(option)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle(localization.text(.filters))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localization.text(.reset)) {
                        onReset()
                        syncPriceFieldsFromCriteria()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.text(.apply)) {
                        applyPriceFieldsToCriteria()
                        onApply()
                        dismiss()
                    }
                }
            }
            .onAppear {
                syncPriceFieldsFromCriteria()
            }
        }
    }

    private var productTypeBinding: Binding<String> {
        Binding(
            get: { criteria.productType ?? "" },
            set: { criteria.productType = $0.isEmpty ? nil : $0 }
        )
    }

    private var vendorBinding: Binding<String> {
        Binding(
            get: { criteria.vendor ?? "" },
            set: { criteria.vendor = $0.isEmpty ? nil : $0 }
        )
    }

    private var statusBinding: Binding<String> {
        Binding(
            get: { criteria.status?.rawValue ?? "" },
            set: { criteria.status = $0.isEmpty ? nil : ProductStatusFilter(rawValue: $0) }
        )
    }

    private func syncPriceFieldsFromCriteria() {
        minPriceText = criteria.minPrice.map { "\($0)" } ?? ""
        maxPriceText = criteria.maxPrice.map { "\($0)" } ?? ""
    }

    private func applyPriceFieldsToCriteria() {
        criteria.minPrice = Decimal(string: minPriceText.trimmingCharacters(in: .whitespacesAndNewlines))
        criteria.maxPrice = Decimal(string: maxPriceText.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

#Preview {
    ProductFilterSheet(
        criteria: .constant(ProductFilterCriteria()),
        productTypes: ["ACCESSORIES", "SHOES"],
        vendors: ["ADIDAS", "NIKE"],
        showsVendorFilter: true,
        onApply: {},
        onReset: {}
    )
    .environmentObject(LocalizationManager())
}
