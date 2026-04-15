// ─────────────────────────────────────────────────────
// This View shows the registration form.
// When registration succeeds, authVM.isLoggedIn becomes true,
// ─────────────────────────────────────────────────────
//  Last updated by Jeremy Wang on 4/1/26.

import SwiftUI

struct RegisterView: View {

    // Receives the same AuthViewModel from LoginView
    @ObservedObject var authVM: AuthViewModel

    // Local state for form fields
    @State private var email           = ""
    @State private var password        = ""
    @State private var confirmPassword = ""

    // Used to dismiss this sheet when done
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Spacer()

                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Register to get started")
                    .foregroundStyle(.secondary)

                // ── Input fields ─────────────────────────────
                VStack(spacing: 14) {

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    SecureField("Password (min 6 characters)", text: $password)  //Masking vs. encryption
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // ── Error message ────────────────────────────
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // ── Register button ──────────────────────────
                Button {
                    // Local validation before calling Firebase
                    guard password == confirmPassword else {
                        authVM.errorMessage = "Passwords do not match."
                        return
                    }
                    authVM.register(email: email, password: password)
                } label: {
                    Group {
                        if authVM.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Register")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(authVM.isLoading)

                // Back to login
                Button("Already have an account? Log In") {
                    dismiss()
                }
                .font(.subheadline)
                .foregroundStyle(.blue)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
