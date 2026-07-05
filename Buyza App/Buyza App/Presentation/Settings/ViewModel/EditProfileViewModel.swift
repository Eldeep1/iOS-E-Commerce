//
//  EditProfileViewModel.swift
//  Buyza App
//

import Foundation

@MainActor
final class EditProfileViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol
    private let updateUserProfileUseCase: UpdateUserProfileUseCaseProtocol

    init(
        getUserProfileUseCase: GetUserProfileUseCaseProtocol? = nil,
        updateUserProfileUseCase: UpdateUserProfileUseCaseProtocol? = nil
    ) {
        let profileRepo = ProfileRepoImp(
            remoteDataSource: ShopifyProfileDataSource(),
            authService: FirebaseServices()
        )
        self.getUserProfileUseCase = getUserProfileUseCase ?? GetUserProfileUseCase(repository: profileRepo)
        self.updateUserProfileUseCase = updateUserProfileUseCase ?? UpdateUserProfileUseCase(repository: profileRepo)
    }

    func loadProfile() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let profile = try await getUserProfileUseCase.execute()
                firstName = profile.firstName
                lastName = profile.lastName
                email = profile.email
                phone = profile.phone
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func saveProfile(localization: LocalizationManager) {
        guard validate() else { return }

        Task {
            isSaving = true
            errorMessage = nil
            successMessage = nil
            do {
                let profile = UserProfile(
                    firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                    lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                    email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                    phone: phone.trimmingCharacters(in: .whitespacesAndNewlines)
                )
                let updated = try await updateUserProfileUseCase.execute(profile: profile)
                firstName = updated.firstName
                lastName = updated.lastName
                email = updated.email
                phone = updated.phone
                successMessage = localization.text(.profileUpdated)
            } catch {
                errorMessage = error.localizedDescription
            }
            isSaving = false
        }
    }

    private func validate() -> Bool {
        if firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = L10n.firstNameRequired.text(for: AppLanguage.stored)
            return false
        }
        return true
    }
}
