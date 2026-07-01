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
        self.city = address.city
        self.country = address.country
        self.isDefault = address.isDefault
        self.updateAddressUseCase = updateAddressUseCase
    }


    var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty &&
        !streetAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !country.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var fullNameError: String? {
        guard !fullName.isEmpty else { return nil }
        return fullName.trimmingCharacters(in: .whitespaces).count < 3 ? "Enter a valid full name" : nil
    }

    var phoneError: String? {
        guard !phoneNumber.isEmpty else { return nil }
        let digits = phoneNumber.filter { $0.isNumber }
        return digits.count < 7 ? "Enter a valid phone number" : nil
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
