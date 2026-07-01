//
//  AddAddressView.swift
//  Buyza App
//

import SwiftUI

struct AddAddressView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddAddressViewModel
    
    init(viewModel: AddAddressViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Delivery Address")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("Fill in the details below to add a new delivery address.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                    }

                    // Form
                    AddAddressForm(viewModel: viewModel)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }

            // Save Button Footer
            saveButton
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isFormValid)
        .alert("Address Saved", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Your new delivery address has been saved successfully.")
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Navigation Bar

    private var navigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text("Add Address")
                .font(.headline)
                .fontWeight(.bold)
                .tracking(1)

            Spacer()

            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 8)
        .padding(.top, 4)
        .background(Color(.systemBackground))
    }

    // MARK: - Save Button

    private var saveButton: some View {
        VStack {
            Button(action: {
                Task { await viewModel.save() }
            }) {
                HStack(spacing: 10) {
                    if viewModel.isSaving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                        Text("Save Address")
                            .font(.headline)
                    }
                }
                .foregroundColor(Color(.systemBackground))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(viewModel.isFormValid ? Color.primary : Color.gray.opacity(0.4))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(viewModel.isFormValid ? 0.08 : 0), radius: 8, x: 0, y: 4)
            }
            .disabled(!viewModel.isFormValid || viewModel.isSaving)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
        )
    }
}
