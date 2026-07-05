//
//  EditProfileView.swift
//  Buyza App
//

import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel = EditProfileViewModel()
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView(localization.text(.loadingProfile))
                        .padding(.top, 40)
                } else {
                    AddressInputField(
                        label: localization.text(.firstName),
                        placeholder: "John",
                        icon: "person",
                        text: $viewModel.firstName
                    )

                    AddressInputField(
                        label: localization.text(.lastName),
                        placeholder: "Doe",
                        icon: "person",
                        text: $viewModel.lastName
                    )

                    AddressInputField(
                        label: localization.text(.email),
                        placeholder: "john@example.com",
                        icon: "envelope",
                        text: $viewModel.email,
                        keyboardType: .emailAddress
                    )
                    .disabled(true)
                    .opacity(0.7)

                    AddressInputField(
                        label: localization.text(.phone),
                        placeholder: "+1 234 567 8900",
                        icon: "phone",
                        text: $viewModel.phone,
                        keyboardType: .phonePad
                    )

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let successMessage = viewModel.successMessage {
                        Text(successMessage)
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        viewModel.saveProfile(localization: localization)
                    } label: {
                        if viewModel.isSaving {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text(localization.text(.saveChanges))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(viewModel.isSaving)
                }
            }
            .padding(20)
        }
        .background(Color(.systemBackground))
        .navigationTitle(localization.text(.editProfile))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadProfile()
        }
    }
}

#Preview {
    NavigationView {
        EditProfileView()
            .environmentObject(LocalizationManager())
    }
}
