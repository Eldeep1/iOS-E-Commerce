//
//  HomeView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel : HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HomeHeader()

                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Categories")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                            
                            if viewModel.isCategoriesLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            } else {
                                CategoriesListView(viewModel: viewModel)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Brands")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                            
                            if viewModel.isBrandsLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            } else {
                                BrandsListView(viewModel: viewModel)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Recommendations")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                            
                            if viewModel.isProductsLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            } else {
                                ProductsGrid(viewModel: viewModel)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
