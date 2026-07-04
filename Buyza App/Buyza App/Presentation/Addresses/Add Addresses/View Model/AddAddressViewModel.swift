//
//  AddAddressViewModel.swift
//  Buyza App
//

import Foundation

@MainActor
final class AddAddressViewModel: ObservableObject {

    private let addAddressUseCase: AddAddressUseCaseProtocol

    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var streetAddress: String = ""
    @Published var city: String = "Birmingham"
    @Published var province: String = "Alabama"
    @Published var zip: String = ""
    @Published var country: String = "United States"
    @Published var isDefault: Bool = false

    @Published var isSaving: Bool = false
    @Published var showSuccessAlert: Bool = false
    @Published var errorMessage: String? = nil

    
    init(addAddressUseCase: AddAddressUseCaseProtocol) {
        self.addAddressUseCase = addAddressUseCase
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

        let newAddress = Address(
            id: UUID().uuidString, // Shopify assigns ID upon creation, but domain model requires non-optional id
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
            _ = try await addAddressUseCase.execute(address: newAddress)
            isSaving = false
            showSuccessAlert = true
        } catch {
            isSaving = false
            errorMessage = error.localizedDescription
        }
    }
}
