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
    // @State is a SwiftUI property wrapper used to store view state.
    // When the value changes, SwiftUI automatically refreshes the UI.
    
    // Here, it stores the text currently typed by the user in the TextField.
    // Because it uses @State, SwiftUI automatically updates the UI when the value changes.
    @State private var newComment: String = ""

    // Stores a list of submitted comments entered by the user.
    // The view refreshes automatically whenever a new comment is added to this array.
    @State private var comments: [String] = []
    
    // The body property is required by the View protocol. It describes the UI layout for this view.
    var body: some View {
        //ZStack is a layered view container
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
                
                //HStack that shows my comment box.
                HStack{
                    Text("Comment: 💬")
                        .foregroundColor(.white)
                    //Here, TextField is a view, "Add your comments here" is the placeholder text, and $newComment is a text binding that stores what the user types.
                    TextField("Add your comments here", text: $newComment)
                        .frame(height: 40)  //height here is called a parameter (argument) of the frame modifier.
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding()
                
            }
            .padding()  //This is a modifier for the VStack
            
            
        }
    }
}

#Preview {
    ProfileView()
}
