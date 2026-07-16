//
//  EditAddressViewModel.swift
//  Buyza App
//

import Foundation

@MainActor
final class EditAddressViewModel: ObservableObject {

    private let updateAddressUseCase: UpdateAddressUseCaseProtocol

    @Published var firstName: String
    @Published var lastName: String
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
        self.firstName = address.firstName
        self.lastName = address.lastName
        self.phoneNumber = address.phoneNumber
        self.streetAddress = address.streetAddress
        self.province = address.province
        self.city = address.city
        self.zip = address.zip
        self.country = address.country.isEmpty ? "Egypt" : address.country
        self.isDefault = address.isDefault
        self.updateAddressUseCase = updateAddressUseCase
    }


    var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty && firstNameError == nil &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty && lastNameError == nil &&
        !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty && phoneError == nil &&
        !streetAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !country.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var firstNameError: String? {
        guard !firstName.isEmpty else { return nil }
        return firstName.trimmingCharacters(in: .whitespaces).count < 2 ? "Enter a valid first name" : nil
    }

    var lastNameError: String? {
        guard !lastName.isEmpty else { return nil }
        return lastName.trimmingCharacters(in: .whitespaces).count < 2 ? "Enter a valid last name" : nil
    }

    var phoneError: String? {
        guard !phoneNumber.isEmpty else { return nil }
        return phoneNumber.trimmingCharacters(in: .whitespaces).count < 6 ? "Enter a valid phone number" : nil
    }

    var zipError: String? {
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
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
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
