//
//  AddressListContent.swift
//  Buyza App
//

import SwiftUI

struct AddressListContent: View {
    @ObservedObject var viewModel: AddressSelectionViewModel
    @State private var addressToEdit: Address? = nil
    @State private var navigateToEdit: Bool = false
    @State private var addressToDelete: Address? = nil
    @State private var showDeleteAlert: Bool = false
    @State private var navigateToPayment: Bool = false

    var body: some View {
        let addressDataSource = ShopifyAddressDataSource()
        let repo = AddressRepositoryImp(remoteDataSource: addressDataSource)
        let addAddressUseCase = AddAddressUseCase(repository: repo)
        let addAddressViewModel = AddAddressViewModel(addAddressUseCase: addAddressUseCase)

        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
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
                            },
                            onDelete: {
                                addressToDelete = address
                                showDeleteAlert = true
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
                    guard viewModel.selectedAddress != nil else { return }
                    navigateToPayment = true
                }
            )
        }
        .background(
            Group {
                NavigationLink(
                    destination: addressToEdit.map { EditAddressView(address: $0) },
                    isActive: $navigateToEdit
                ) { EmptyView() }
                
                NavigationLink(
                    destination: paymentDestination(),
                    isActive: $navigateToPayment
                ) { EmptyView() }
            }
        )
        .alert("Delete Address?", isPresented: $showDeleteAlert, presenting: addressToDelete) { address in
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task { await viewModel.deleteAddress(id: address.id) }
            }
        } message: { address in
            Text("Are you sure you want to delete \(address.fullName)'s address?")
        }
    }

    @ViewBuilder
    private func paymentDestination() -> some View {
        if let address = viewModel.selectedAddress {
            let repo = CheckoutRepositoryImp()

            let paymentVM = PaymentViewModel(
                address: address,
                customerID: viewModel.customerGID,
                createCheckoutUseCase: CreateCheckoutUseCase(repository: repo),
                applyDiscountUseCase: ApplyDiscountUseCase(repository: repo),
                placeCODOrderUseCase: PlaceCODOrderUseCase(repository: repo),
                fetchLatestOrderUseCase: FetchLatestOrderUseCase(repository: repo)
            )
            PaymentView(viewModel: paymentVM)
        } else {
            EmptyView()
        }
    }
}
