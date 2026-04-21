//
//  AuthViewModel.swift
//  FlaglerSwiftUI
//
//  Last Updated by Jeremy Wang on 4/1/26.
// ============================================================
// This ViewModel handles Login and Registration.
// It talks to Firebase Auth and publishes state to the Views.
//
//  Same pattern as ConverterViewModel —
//   @Published properties + intent functions
// ============================================================

import Foundation
import Combine
import FirebaseAuth   // Firebase Authentication SDK

@MainActor
class AuthViewModel: ObservableObject {

  // --------------------------------------------------------
  // MARK: - @Published State
  // --------------------------------------------------------
  // These properties drive what the View shows.
  // When any of these change, SwiftUI rebuilds the View.
  // --------------------------------------------------------

  // The currently signed-in Firebase user
  // nil means nobody is logged in
  @Published var currentUser: User? = nil

  // Controls whether the app shows Login or the main app
  // true  = user is logged in → show CourseListView
  // false = not logged in     → show LoginView
  @Published var isLoggedIn: Bool = false

  // Error message to display when login/register fails
  @Published var errorMessage: String? = nil

  // true while Firebase is processing a request
  // Used to show a loading spinner in the View
  @Published var isLoading: Bool = false

  // --------------------------------------------------------
  // MARK: - Initializer
  // --------------------------------------------------------
  // Runs once when the app launches.
  // Checks if a user is already logged in from a previous
  // session — Firebase remembers the last logged-in user.
  // --------------------------------------------------------
  init() {
      // Auth.auth().currentUser is non-nil if someone is
      // already logged in from a previous app session
      if let user = Auth.auth().currentUser {
          self.currentUser = user
          self.isLoggedIn  = true
      }
  }

  // --------------------------------------------------------
  // MARK: - Intent: Register
  // --------------------------------------------------------
  // Called when the user taps "Register" in RegisterView.
  // Creates a new account in Firebase Authentication.
  //
  // Parameters:
  //   email    — the email the user typed
  //   password — the password the user typed
  // --------------------------------------------------------
  func register(email: String, password: String) {
      errorMessage = nil
      isLoading    = true

      // Basic validation before calling Firebase
      guard !email.isEmpty, !password.isEmpty else {
          errorMessage = "Please enter your email and password."
          isLoading    = false
          return
      }

      guard password.count >= 6 else {
          errorMessage = "Password must be at least 6 characters."
          isLoading    = false
          return
      }

      // createUser — Firebase creates the account
      // The result comes back in a closure (async)
      Auth.auth().createUser(withEmail: email, password: password) { result, error in

          // isLoading is done — whether success or failure
          self.isLoading = false

          // If there was an error, show it to the user
          if let error = error {
              self.errorMessage = error.localizedDescription
              return
          }

          // Success — store the user and flip the login flag
          if let user = result?.user {
              self.currentUser = user
              self.isLoggedIn  = true
          }
      }
  }

  // --------------------------------------------------------
  // MARK: - Intent: Login
  // --------------------------------------------------------
  // Called when the user taps "Log In" in LoginView.
  // Signs in with an existing Firebase account.
  // --------------------------------------------------------
  func login(email: String, password: String) {
      errorMessage = nil
      isLoading    = true

      guard !email.isEmpty, !password.isEmpty else {
          errorMessage = "Please enter your email and password."
          isLoading    = false
          return
      }

      // signIn — Firebase checks the email/password
      Auth.auth().signIn(withEmail: email, password: password) { result, error in

          self.isLoading = false

          if let error = error {
              self.errorMessage = error.localizedDescription
              return
          }

          if let user = result?.user {
              self.currentUser = user
              self.isLoggedIn  = true
          }
      }
  }

  // --------------------------------------------------------
  // MARK: - Intent: Logout
  // --------------------------------------------------------
  // Called when the user taps "Log Out".
  // Signs out of Firebase and returns to the Login screen.
  // --------------------------------------------------------
  func logout() {
      do {
          // try because Firebase can throw an error on signOut
          try Auth.auth().signOut()

          // Clear our local state
          self.currentUser = nil
          self.isLoggedIn  = false

      } catch {
          self.errorMessage = error.localizedDescription
      }
  }
}
