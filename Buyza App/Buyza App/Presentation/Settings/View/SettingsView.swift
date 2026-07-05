//
//  SettingsView.swift
//  Buyza App
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        NavigationView {
            List {
                Section {
                    if appState.isGuest {
                        settingsRow(
                            title: localization.text(.editProfile),
                            icon: "person.crop.circle",
                            color: .blue
                        ) {
                            viewModel.showSignInAlert = true
                        }
                    } else {
                        NavigationLink {
                            EditProfileView()
                        } label: {
                            settingsLabel(
                                title: localization.text(.editProfile),
                                icon: "person.crop.circle",
                                color: .blue
                            )
                        }
                    }

                    Button {
                        viewModel.showLanguageSheet = true
                    } label: {
                        HStack {
                            settingsLabel(
                                title: localization.text(.language),
                                icon: "globe",
                                color: .green
                            )
                            Spacer()
                            Text(localization.currentLanguage.displayName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }

                if !appState.isGuest {
                    Section {
                        Button(role: .destructive) {
                            viewModel.showLogoutAlert = true
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 18))
                                    .foregroundColor(.red)
                                    .frame(width: 28)

                                if viewModel.isLoggingOut {
                                    ProgressView()
                                } else {
                                    Text(localization.text(.logout))
                                        .font(.body)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .disabled(viewModel.isLoggingOut)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(localization.text(.settings))
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $viewModel.showLanguageSheet) {
                LanguagePickerSheet()
            }
            .alert(localization.text(.logoutConfirmation), isPresented: $viewModel.showLogoutAlert) {
                Button(localization.text(.cancel), role: .cancel) { }
                Button(localization.text(.signOut), role: .destructive) {
                    viewModel.logout(appState: appState)
                }
            } message: {
                Text(localization.text(.logoutMessage))
            }
            .alert(localization.text(.signInRequired), isPresented: $viewModel.showSignInAlert) {
                Button(localization.text(.cancel), role: .cancel) { }
                Button(localization.text(.signIn)) {
                    appState.isGuest = false
                    appState.currentRoute = .auth
                }
            } message: {
                Text(localization.text(.signInRequiredMessage))
            }
            .alert(localization.text(.error), isPresented: $viewModel.showErrorAlert) {
                Button(localization.text(.ok), role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    private func settingsRow(
        title: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            settingsLabel(title: title, icon: icon, color: color)
        }
        .foregroundColor(.primary)
    }

    private func settingsLabel(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 28)

            Text(title)
                .font(.body)
        }
        .padding(.vertical, 4)
    }
}

private struct LanguagePickerSheet: View {
    @EnvironmentObject private var localization: LocalizationManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(AppLanguage.allCases) { language in
                    Button {
                        localization.currentLanguage = language
                        dismiss()
                    } label: {
                        HStack {
                            Text(language.displayName)
                                .foregroundColor(.primary)
                            Spacer()
                            if localization.currentLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
            .navigationTitle(localization.text(.language))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.text(.cancel)) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppStateManager())
        .environmentObject(LocalizationManager())
}
