import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel: ForgotPasswordViewModel
    @Environment(\.dismiss) var dismiss
    
    init(sendPasswordResetUseCase: SendPasswordResetUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: ForgotPasswordViewModel(sendPasswordResetUseCase: sendPasswordResetUseCase))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.93, green: 0.92, blue: 0.98), Color(red: 0.96, green: 0.96, blue: 0.98)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                VStack(spacing: 8) {
                    Text("Reset Password")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Enter your email address to receive a password reset link.")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("EMAIL ADDRESS")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        ZStack(alignment: .leading) {
                            if viewModel.email.isEmpty {
                                Text(verbatim: "name@example.com")
                                    .foregroundColor(Color.gray.opacity(0.6))
                            }
                            TextField("", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(.black)
                                .tint(.black)
                        }
                        .modifier(InputFieldModifier())
                    }
                    
                    Button(action: {
                        viewModel.sendResetLink()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .cornerRadius(28)
                        } else {
                            Text("Send Reset Link")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .cornerRadius(28)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $viewModel.showErrorAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage ?? "An unexpected error occurred.")
        })
        .alert("Email Sent", isPresented: $viewModel.showSuccessAlert, actions: {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }, message: {
            Text("A password reset link has been sent to your email address.")
        })
    }
}
