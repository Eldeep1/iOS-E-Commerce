//
//  AddressSelectionViewModel.swift
//  Buyza App
//

import Foundation

@MainActor
final class AddressSelectionViewModel: ObservableObject {
    
    // MARK: - Published State
    @Published var addresses: [AddressUIModel] = []
    @Published var selectedAddressId: String? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Computed Properties
    
    var hasAddresses: Bool {
        !addresses.isEmpty
    }
    
    var selectedAddress: AddressUIModel? {
        addresses.first { $0.id == selectedAddressId }
    }
    
    // MARK: - Lifecycle
    
    func loadAddresses() async {
        isLoading = true
        errorMessage = nil
        
        // Simulated network delay — replace with real use case call later
        try? await Task.sleep(nanoseconds: 600_000_000)
        
        // TODO: Replace with real data from use case
        // For now, load mock data. Toggle to [] to test empty state.
        addresses = AddressUIModel.mocks
        
        // Auto-select the default address, otherwise the first one
        if let defaultAddress = addresses.first(where: { $0.isDefault }) {
            selectedAddressId = defaultAddress.id
        } else {
            selectedAddressId = addresses.first?.id
        }
        
        isLoading = false
    }
    
    func select(address: AddressUIModel) {
        selectedAddressId = address.id
    }
    
    func deleteAddress(id: String) {
        addresses.removeAll { $0.id == id }
        // If the deleted address was selected, fall back to first available
        if selectedAddressId == id {
            selectedAddressId = addresses.first?.id
        }
    }
}
