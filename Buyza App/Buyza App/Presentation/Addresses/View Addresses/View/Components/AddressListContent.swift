//
//  AddressListContent.swift
//  Buyza App
//

import SwiftUI

struct AddressListContent: View {
    @ObservedObject var viewModel: AddressSelectionViewModel
    // Navigation handled directly by NavigationLink
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    NavigationLink(destination: AddAddressView()) {
                        HStack {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .bold))
                            Text("Add New Address")
                                .font(.headline)
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primary, style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                        )
                    }
                    .padding(.top, 16)
                    
                    // Address Cards
                    ForEach(viewModel.addresses) { address in
                        AddressCardView(
                            address: address,
                            isSelected: viewModel.selectedAddressId == address.id,
                            onSelect: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    viewModel.select(address: address)
                                }
                            },
                            onEdit: {
                                print("Edit address \(address.id)")
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            
            // Continue Footer
            AddressContinueButton(
                selectedAddressId: viewModel.selectedAddressId,
                onContinue: {
                    guard let address = viewModel.selectedAddress else { return }
                    print("Proceeding to Payment with address: \(address.fullAddressString)")
                }
            )
        }
    }
}
