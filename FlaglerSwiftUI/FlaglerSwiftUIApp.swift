//
//  FlaglerSwiftUIApp.swift
//  FlaglerSwiftUI
//
//  Last Updated by Jeremy Wang on 3/2/26.
//

import SwiftUI
import FirebaseCore

//this is from the SDK white paper - Only needs to register once!
class AppDelegate: NSObject, UIApplicationDelegate {
 func application(_ application: UIApplication,
                  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
   FirebaseApp.configure()
   return true
 }
}

@main
struct FlaglerSwiftUIApp: App {
   // register app delegate for Firebase setup
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

   @StateObject private var authVM = AuthViewModel()


   var body: some Scene {
       WindowGroup {

           // Gate the entire app behind login.
           // If not logged in, only LoginView is shown.
           // Once logged in, the full TabView appears.
           if authVM.isLoggedIn {

               // Main app — only accessible after login
               TabView {

                   ProfileView()
                       .tabItem {
                           Label("Profile", systemImage: "person.fill")
                       }

                   CalculatorView()
                       .tabItem {
                           Label("Calculator", systemImage: "plus.slash.minus")
                       }

                   TipView()
                       .tabItem {
                           Label("Tip Cal", systemImage: "dollarsign")
                       }
                 
                   
                   CourseListView(authVM: authVM)
                       .tabItem {
                           Label("Courses", systemImage: "book.fill")
                       }
                
               }

           } else {

               // Not logged in — show login screen only
               // The entire app is hidden until login succeeds
               LoginView(authVM: authVM)
           }
       }
   }
}

