//
//  AddAddressForm.swift
//  Buyza App
//

import SwiftUI

struct AddAddressForm: View {
    @ObservedObject var viewModel: AddAddressViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Full Name
            AddressInputField(
                label: "Full Name",
                placeholder: "e.g. John Doe",
                icon: "person",
                text: $viewModel.fullName,
                errorMessage: viewModel.fullNameError
            )

            // Phone Number
            AddressInputField(
                label: "Phone Number",
                placeholder: "e.g. +1 234 567 8900",
                icon: "phone",
                text: $viewModel.phoneNumber,
                keyboardType: .phonePad,
                errorMessage: viewModel.phoneError
            )

            // Street Address
            AddressInputField(
                label: "Street Address",
                placeholder: "e.g. 123 Apple Park Way",
                icon: "mappin",
                text: $viewModel.streetAddress
            )

            // City
            AddressInputField(
                label: "City",
                placeholder: "e.g. New York",
                icon: "building.2",
                text: $viewModel.city
            )

            // Country
            AddressInputField(
                label: "Country",
                placeholder: "e.g. United States",
                icon: "globe",
                text: $viewModel.country
            )

            // Set as Default Toggle
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Set as Default Address")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                    Text("This address will be pre-selected at checkout")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Toggle("", isOn: $viewModel.isDefault)
                    .labelsHidden()
            }
            .padding(14)
            .background(Color(.systemGray6).opacity(0.6))
            .cornerRadius(10)
        }
    }
}
