//
//  AddAddressViewModel.swift
//  Buyza App
//

import Foundation

@MainActor
final class AddAddressViewModel: ObservableObject {

    private let addAddressUseCase: AddAddressUseCaseProtocol

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var streetAddress: String = ""
    @Published var city: String = ""
    @Published var province: String = ""
    @Published var zip: String = ""
    @Published var country: String = "Egypt"
    @Published var isDefault: Bool = false

    @Published var isSaving: Bool = false
    @Published var showSuccessAlert: Bool = false
    @Published var errorMessage: String? = nil

    
    init(addAddressUseCase: AddAddressUseCaseProtocol) {
        self.addAddressUseCase = addAddressUseCase
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

        let newAddress = Address(
            id: UUID().uuidString,
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
            _ = try await addAddressUseCase.execute(address: newAddress)
            isSaving = false
            showSuccessAlert = true
        } catch {
            isSaving = false
            errorMessage = error.localizedDescription
        }
    }
}
