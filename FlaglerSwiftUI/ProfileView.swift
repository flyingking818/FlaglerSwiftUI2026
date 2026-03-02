//
//  ContentView.swift
//  FlaglerSwiftUI
//
//  Created by Jeremy Wang on 3/2/26.
//

import SwiftUI
// Define a new structure named ProfileView.
// In SwiftUI, views are typically defined as structs (value types).

// Conforms to the View protocol (similar to inheritance, but different!)

// View represents any UI element in SwifUI. They don't start with dot!
// Modifiers are methods that change a view. They start with dot!!!

struct ProfileView: View {
    // The body property is required by the View protocol. It describes the UI layout for this view.
    var body: some View {
        //Zack is a layered view container
        ZStack{
            //Color is actually a view here.
            Color(UIColor(red: 0.75, green: 0.22, blue: 0.17, alpha: 1))
                .ignoresSafeArea()
                        
            VStack {
                //ImageView
                Image("Jeremy")
                    //These are modifiers of Image! :)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.yellow, lineWidth: 10))
                //TextView
                Text("Hello, world! My name is Jeremy")
                    //These are modifers of Text.
                    .font(Font.title3.bold())
                    .italic()
            }
            .padding()  //This is a modifier for the VStack
            
            
        }
    }
}

#Preview {
    ProfileView()
}
