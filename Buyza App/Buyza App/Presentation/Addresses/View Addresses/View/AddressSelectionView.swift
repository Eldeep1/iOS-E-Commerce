//
//  AddressSelectionView.swift
//  Buyza App
//

import SwiftUI

struct AddressSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddressSelectionViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            AddressNavigationBar(onDismiss: { dismiss() })

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.3)
                Spacer()
            } else if !viewModel.hasAddresses {
                EmptyAddressView()
            } else {
                AddressListContent(viewModel: viewModel)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .task { await viewModel.loadAddresses() }
    }
}
