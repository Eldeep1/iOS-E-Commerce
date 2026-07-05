//
//  EmptyAddressView.swift
//  Buyza App
//

import SwiftUI

struct EmptyAddressView: View {
    @EnvironmentObject private var localization: LocalizationManager
    
    var body: some View {
        let addressDataSource = ShopifyAddressDataSource()
        let repo = AddressRepositoryImp(remoteDataSource: addressDataSource)
        let addAddressUseCase = AddAddressUseCase(repository: repo)
        let viewModel = AddAddressViewModel(addAddressUseCase:addAddressUseCase)
        
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "mappin.slash.circle")
                .font(.system(size: 70))
                .foregroundColor(.secondary.opacity(0.3))
            
            VStack(spacing: 8) {
                Text(localization.text(.noSavedAddresses))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(localization.text(.noSavedAddressesSubtitle))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            NavigationLink(destination: AddAddressView(viewModel: viewModel)) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                    Text(localization.text(.addFirstAddress))
                        .font(.headline)
                }
                .foregroundColor(Color(.systemBackground))
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(Color.primary)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}
