//
//  AddressSelectionViewModel.swift
//  Buyza App
//

import Foundation

@MainActor
final class AddressSelectionViewModel: ObservableObject {
    
    private let getAddressesUseCase: GetAddressesUseCaseProtocol
    private let deleteAddressUseCase: DeleteAddressUseCaseProtocol
    
    @Published var addresses: [Address] = []
    @Published var selectedAddressId: String? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Computed Properties
    
    var hasAddresses: Bool {
        !addresses.isEmpty
    }
    
    var selectedAddress: Address? {
        addresses.first { $0.id == selectedAddressId }
    }
        
    init(getAddressesUseCase: GetAddressesUseCaseProtocol , deleteAddressUseCase: DeleteAddressUseCaseProtocol) {
        self.getAddressesUseCase = getAddressesUseCase
        self.deleteAddressUseCase = deleteAddressUseCase
    }
    
    func loadAddresses() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.addresses = try await getAddressesUseCase.execute()
            
            // Auto-select the default address, otherwise the first one
            if let defaultAddress = addresses.first(where: { $0.isDefault }) {
                selectedAddressId = defaultAddress.id
            } else if selectedAddressId == nil {
                selectedAddressId = addresses.first?.id
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func select(address: Address) {
        selectedAddressId = address.id
    }
    
    func deleteAddress(id: String) async {
        do {
            try await deleteAddressUseCase.execute(id: id)
            addresses.removeAll { $0.id == id }
            
            if selectedAddressId == id {
                selectedAddressId = addresses.first?.id
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
