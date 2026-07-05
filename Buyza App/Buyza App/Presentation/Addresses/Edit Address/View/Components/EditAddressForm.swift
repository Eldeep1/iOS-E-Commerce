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
            VStack(alignment: .leading, spacing: 8) {
                Text(localization.text(.country))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)

                HStack(spacing: 12) {
                    countryButton(title: localization.text(.unitedStates), flag: "🇺🇸", isSelected: viewModel.country == "United States") {
                        viewModel.country = "United States"
                        if !GeographicData.usStates.contains(viewModel.province) {
                            let newProv = GeographicData.usStates.first ?? ""
                            viewModel.province = newProv
                            viewModel.city = GeographicData.cities(for: newProv).first ?? ""
                        } else if !GeographicData.cities(for: viewModel.province).contains(viewModel.city) {
                            viewModel.city = GeographicData.cities(for: viewModel.province).first ?? ""
                        }
                    }

                    countryButton(title: localization.text(.canada), flag: "🇨🇦", isSelected: viewModel.country == "Canada") {
                        viewModel.country = "Canada"
                        if !GeographicData.canadianProvinces.contains(viewModel.province) {
                            let newProv = GeographicData.canadianProvinces.first ?? ""
                            viewModel.province = newProv
                            viewModel.city = GeographicData.cities(for: newProv).first ?? ""
                        } else if !GeographicData.cities(for: viewModel.province).contains(viewModel.city) {
                            viewModel.city = GeographicData.cities(for: viewModel.province).first ?? ""
                        }
                    }
                }
            }

            AddressInputField(
                label: localization.text(.fullName),
                placeholder: "e.g. John Doe",
                icon: "person",
                text: $viewModel.fullName,
                errorMessage: viewModel.fullNameError
            )

            AddressInputField(
                label: localization.text(.phone),
                placeholder: "e.g. +1 234 567 8900",
                icon: "phone",
                text: $viewModel.phoneNumber,
                keyboardType: .phonePad,
                errorMessage: viewModel.phoneError
            )

            AddressInputField(
                label: localization.text(.streetAddress),
                placeholder: "e.g. 123 Apple Park Way",
                icon: "mappin",
                text: $viewModel.streetAddress
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.country == "Canada" ? localization.text(.province) : localization.text(.state))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)

                Menu {
                    let options = viewModel.country == "Canada" ? GeographicData.canadianProvinces : GeographicData.usStates
                    ForEach(options, id: \.self) { option in
                        Button(option) {
                            viewModel.province = option
                            if !GeographicData.cities(for: option).contains(viewModel.city) {
                                viewModel.city = GeographicData.cities(for: option).first ?? ""
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "map")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .frame(width: 24)

                        Text(viewModel.province.isEmpty ? (viewModel.country == "Canada" ? localization.text(.province) : localization.text(.state)) : viewModel.province)
                            .font(.system(size: 16))
                            .foregroundColor(viewModel.province.isEmpty ? .gray.opacity(0.5) : .primary)

                        Spacer()

                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6).opacity(0.6))
                    .cornerRadius(10)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(localization.text(.city))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)

                Menu {
                    let cities = GeographicData.cities(for: viewModel.province)
                    ForEach(cities, id: \.self) { cityOption in
                        Button(cityOption) {
                            viewModel.city = cityOption
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "building.2")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .frame(width: 24)

                        Text(viewModel.city.isEmpty ? localization.text(.city) : viewModel.city)
                            .font(.system(size: 16))
                            .foregroundColor(viewModel.city.isEmpty ? .gray.opacity(0.5) : .primary)

                        Spacer()

                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6).opacity(0.6))
                    .cornerRadius(10)
                }
            }

            AddressInputField(
                label: viewModel.country == "Canada" ? localization.text(.postalCode) : localization.text(.zipCode),
                placeholder: viewModel.country == "Canada" ? "e.g. K1A 0B1" : "e.g. 90210",
                icon: "number",
                text: $viewModel.zip,
                keyboardType: viewModel.country == "Canada" ? .default : .numbersAndPunctuation,
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
