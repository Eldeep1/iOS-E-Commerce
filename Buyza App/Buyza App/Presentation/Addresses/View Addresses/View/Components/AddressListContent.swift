//
//  AddressListContent.swift
//  Buyza App
//

import SwiftUI

struct AddressListContent: View {
    @ObservedObject var viewModel: AddressSelectionViewModel
    @State private var addressToEdit: Address? = nil
    @State private var navigateToEdit: Bool = false

    var body: some View {
        let addressDataSource = ShopifyAddressDataSource()
        let repo = AddressRepositoryImp(remoteDataSource: addressDataSource)
        let addAddressUseCase = AddAddressUseCase(repository: repo)
        let addAddressViewModel = AddAddressViewModel(addAddressUseCase: addAddressUseCase)

        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    // Hidden NavigationLink for editing — triggered by pencil button
                    NavigationLink(
                        destination: addressToEdit.map { EditAddressView(address: $0) },
                        isActive: $navigateToEdit
                    ) {
                        EmptyView()
                    }

                    NavigationLink(destination: AddAddressView(viewModel: addAddressViewModel)) {
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
                                addressToEdit = address
                                navigateToEdit = true
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
