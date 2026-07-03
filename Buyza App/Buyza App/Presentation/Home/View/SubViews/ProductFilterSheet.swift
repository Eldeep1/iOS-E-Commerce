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

    @State private var minPriceText: String = ""
    @State private var maxPriceText: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Product Type") {
                    Picker("Type", selection: productTypeBinding) {
                        Text("All Types").tag("")
                        ForEach(productTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }

                if showsVendorFilter {
                    Section("Brand / Vendor") {
                        Picker("Vendor", selection: vendorBinding) {
                            Text("All Brands").tag("")
                            ForEach(vendors, id: \.self) { vendor in
                                Text(vendor).tag(vendor)
                            }
                        }
                    }
                }

                Section("Price Range") {
                    TextField("Min price", text: $minPriceText)
                        .keyboardType(.decimalPad)
                    TextField("Max price", text: $maxPriceText)
                        .keyboardType(.decimalPad)
                }

                Section("Availability") {
                    Picker("Published", selection: $criteria.publishedStatus) {
                        ForEach(ProductPublishedStatus.allCases) { status in
                            Text(status.displayName).tag(status)
                        }
                    }

                    Picker("Status", selection: statusBinding) {
                        Text("Any").tag("")
                        ForEach(ProductStatusFilter.allCases) { status in
                            Text(status.displayName).tag(status.rawValue)
                        }
                    }
                }

                Section("Sort By") {
                    Picker("Sort", selection: $criteria.sort) {
                        ForEach(ProductSortOption.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        onReset()
                        syncPriceFieldsFromCriteria()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
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
}
