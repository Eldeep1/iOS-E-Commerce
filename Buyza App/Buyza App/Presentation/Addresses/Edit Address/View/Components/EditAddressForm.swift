//
//  EditAddressForm.swift
//  Buyza App
//

import SwiftUI

struct EditAddressForm: View {
    @ObservedObject var viewModel: EditAddressViewModel
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(spacing: 16) {
                AddressInputField(
                    label: localization.text(.firstName),
                    placeholder: "e.g. John",
                    icon: "person",
                    text: $viewModel.firstName,
                    errorMessage: viewModel.firstNameError
                )

                AddressInputField(
                    label: localization.text(.lastName),
                    placeholder: "e.g. Doe",
                    icon: "person.fill",
                    text: $viewModel.lastName,
                    errorMessage: viewModel.lastNameError
                )
            }

            AddressInputField(
                label: localization.text(.phone),
                placeholder: "e.g. +201001234567",
                icon: "phone",
                text: $viewModel.phoneNumber,
                keyboardType: .phonePad,
                errorMessage: viewModel.phoneError
            )
            
            AddressInputField(
                label: localization.text(.country),
                placeholder: "e.g. Egypt",
                icon: "globe",
                text: $viewModel.country
            )

            AddressInputField(
                label: localization.text(.streetAddress),
                placeholder: "e.g. 123 Apple Park Way",
                icon: "mappin",
                text: $viewModel.streetAddress
            )
            
            HStack(spacing: 16) {
                AddressInputField(
                    label: localization.text(.city),
                    placeholder: "e.g. Cairo",
                    icon: "building.2",
                    text: $viewModel.city
                )
                
                AddressInputField(
                    label: localization.text(.state),
                    placeholder: "e.g. Cairo",
                    icon: "map",
                    text: $viewModel.province
                )
            }

            AddressInputField(
                label: localization.text(.zipCode) + " (Optional)",
                placeholder: "e.g. 11511",
                icon: "number",
                text: $viewModel.zip,
                keyboardType: .default,
                errorMessage: viewModel.zipError
            )

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(localization.text(.setAsDefault))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                    Text(localization.text(.defaultAddressHint))
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

    private func countryButton(title: String, flag: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(flag)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .primary : .secondary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.systemGray6).opacity(isSelected ? 1.0 : 0.4))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 1.5)
            )
        }
    }
}
