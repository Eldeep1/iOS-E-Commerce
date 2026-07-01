//
//  AddAddressViewModel.swift
//  Buyza App
//

import Foundation

@MainActor
final class AddAddressViewModel: ObservableObject {

    // MARK: - Form Fields
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var streetAddress: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
    @Published var isDefault: Bool = false

    // MARK: - State
    @Published var isSaving: Bool = false
    @Published var showSuccessAlert: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Validation

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

        // Simulated save delay — replace with real use case call later
        try? await Task.sleep(nanoseconds: 800_000_000)

        // TODO: Call AddAddressUseCase here
        isSaving = false
        showSuccessAlert = true
    }
}
