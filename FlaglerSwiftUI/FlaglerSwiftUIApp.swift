//
//  FlaglerSwiftUIApp.swift
//  FlaglerSwiftUI
//
//  Created by Jeremy Wang on 3/2/26.
//

import SwiftUI

@main
struct FlaglerSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
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
            }
        }
    }
}
