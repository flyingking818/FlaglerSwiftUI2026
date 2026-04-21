// ============================================================
// This View shows the login form.
// It reads from and calls methods on AuthViewModel.
// It has zero auth logic — only layout.
// ============================================================
//  Last updated by Jeremy Wang on 4/1/26.


import SwiftUI

struct LoginView: View {

    // ─────────────────────────────────────────────────────
    // AuthViewModel is passed in from the App entry point.
    // We use @ObservedObject (not @StateObject) because the
    // parent (the App) owns this ViewModel — we just observe it.
    // ─────────────────────────────────────────────────────
    @ObservedObject var authVM: AuthViewModel

    // ─────────────────────────────────────────────────────
    // Local @State for the text fields.
    // These only live inside this View — they don't need to
    // be in the ViewModel because no other screen needs them.
    // ─────────────────────────────────────────────────────
    @State private var email    = ""
    @State private var password = ""   //rehashing -> match the hashed password in the DB.

    // Controls whether to show the RegisterView sheet
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Spacer()

                // App title
                Text("Welcome to Flagler App!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Sign in to continue")
                    .foregroundStyle(.secondary)

                // ── Input fields ─────────────────────────────
                VStack(spacing: 14) {

                    // $email — two-way binding to our @State
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    // SecureField hides the password characters
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // ── Error message ────────────────────────────
                // Only shows when authVM.errorMessage is not nil
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // ── Login button ─────────────────────────────
                Button {
                    // View calls ViewModel method — no auth logic here
                    authVM.login(email: email, password: password)    //Here, we call different function!
                } label: {
                    // Show spinner while loading, text otherwise
                    // This is a ternary — same as if/else in one line
                    Group {
                        if authVM.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Log In")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(authVM.isLoading)   // disable while loading

                // ── Register link ────────────────────────────
                Button("Don't have an account? Register") {
                    showRegister = true
                }
                .font(.subheadline)
                .foregroundStyle(.blue)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)

            // Show RegisterView as a sheet when showRegister is true
            .sheet(isPresented: $showRegister) {
                RegisterView(authVM: authVM)
            }
        }
    }
}

