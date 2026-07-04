//
//  EditAddressViewModel.swift
//  Buyza App
//

import Foundation

@MainActor
final class EditAddressViewModel: ObservableObject {

    private let updateAddressUseCase: UpdateAddressUseCaseProtocol

    @Published var fullName: String
    @Published var phoneNumber: String
    @Published var streetAddress: String
    @Published var city: String
    @Published var province: String
    @Published var zip: String
    @Published var country: String
    @Published var isDefault: Bool

    @Published var isSaving: Bool = false
    @Published var showSuccessAlert: Bool = false
    @Published var errorMessage: String? = nil

    private let addressId: String


    init(
        address: Address,
        updateAddressUseCase: UpdateAddressUseCaseProtocol) {
        self.addressId = address.id
        self.fullName = address.fullName
        self.phoneNumber = address.phoneNumber
        self.streetAddress = address.streetAddress
        let prov = address.province.isEmpty ? "Alabama" : address.province
        self.province = prov
        self.city = address.city.isEmpty ? (GeographicData.cities(for: prov).first ?? "") : address.city
        self.zip = address.zip
        self.country = address.country.isEmpty ? "United States" : address.country
        self.isDefault = address.isDefault
        self.updateAddressUseCase = updateAddressUseCase
    }


    var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty && fullNameError == nil &&
        !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty && phoneError == nil &&
        !streetAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !province.trimmingCharacters(in: .whitespaces).isEmpty &&
        !zip.trimmingCharacters(in: .whitespaces).isEmpty && zipError == nil &&
        !country.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var fullNameError: String? {
        guard !fullName.isEmpty else { return nil }
        return fullName.trimmingCharacters(in: .whitespaces).count < 3 ? "Enter a valid full name" : nil
    }

    var phoneError: String? {
        guard !phoneNumber.isEmpty else { return nil }
        if GeographicData.isValidPhoneNumber(phoneNumber, in: country) {
            return nil
        } else {
            let sample = GeographicData.samplePhoneNumber(for: province, in: country)
            return "Enter a valid phone number with a real Area Code (e.g. \(sample)-555-0199)"
        }
    }

    var zipError: String? {
        guard !zip.isEmpty else { return nil }
        if !GeographicData.isValidZip(zip, for: province, in: country) {
            let sample = GeographicData.samplePostalCode(for: province, in: country)
            if country == "Canada" {
                return "Enter a valid postal code for \(province) (e.g. \(sample))"
            } else {
                return "Enter a valid ZIP code for \(province) (e.g. \(sample))"
            }
        }
        return nil
    }

    // MARK: - Actions

    func save() async {
        guard isFormValid else {
            errorMessage = "Please fill in all required fields."
            return
        }

        isSaving = true
        errorMessage = nil

        let updated = Address(
            id: addressId,
            fullName: fullName.trimmingCharacters(in: .whitespaces),
            phoneNumber: phoneNumber.trimmingCharacters(in: .whitespaces),
            streetAddress: streetAddress.trimmingCharacters(in: .whitespaces),
            city: city.trimmingCharacters(in: .whitespaces),
            province: province.trimmingCharacters(in: .whitespaces),
            zip: zip.trimmingCharacters(in: .whitespaces),
            country: country.trimmingCharacters(in: .whitespaces),
            isDefault: isDefault
        )

        do {
            _ = try await updateAddressUseCase.execute(address: updated)
            isSaving = false
            showSuccessAlert = true
        } catch {
            isSaving = false
            errorMessage = error.localizedDescription
        }
    }
}
