//
//  AddressSelectionView.swift
//  Buyza App
//

import SwiftUI

struct AddressSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddressSelectionViewModel
    
    init(viewModel: AddressSelectionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            AddressNavigationBar(onDismiss: { dismiss() })

            if viewModel.isLoading && viewModel.addresses.isEmpty {
                Spacer()
                ProgressView()
                    .scaleEffect(1.3)
                Spacer()
            } else if !viewModel.hasAddresses && !viewModel.isLoading {
                EmptyAddressView()
            } else {
                AddressListContent(viewModel: viewModel)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            Task { await viewModel.loadAddresses() }
        }
    }
}
