//
//  ContentView.swift
//  FlaglerSwiftUI
//
//  Created by Jeremy Wang on 3/2/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            Color(UIColor(red: 0.75, green: 0.22, blue: 0.17, alpha: 1))
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world! My name is Jeremy")
                    .font(Font.title3.bold())
                    .italic()
            }
            .padding()
            
            
        }
    }
}

#Preview {
    ProfileView()
}
