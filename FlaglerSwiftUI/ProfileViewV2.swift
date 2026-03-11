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

struct ProfileViewV2: View {
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
                
                //Use CMD+A to select All, then CTRL+I to format
                
                // Button that posts a new comment
                Button(action: {
                    
                    // Remove extra spaces from the beginning and end of the text
                    // This prevents users from submitting comments that contain only spaces
                    if !newComment.trimmingCharacters(in:  .whitespaces).isEmpty {
                        
                        // Insert the new comment at the beginning of the array (index 0)
                        // This makes the most recent comment appear at the top of the list
                        comments.insert(newComment, at: 0)
                        
                        // Clear the text field after posting the comment
                        newComment = ""
                    }
                }) {
                    Text("Post Comment 🎉")
                        .foregroundColor(.white)
                        .padding()  //within the container, margin for neighbots
                        .frame(maxWidth: .infinity)//auto scaling constraint
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // ScrollView allows the user to scroll when there are many comments
                ScrollView {
                    
                    // VStack arranges all comment items vertically
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // Loop through each comment stored in the comments array
                        // SwiftUI automatically updates the UI when the array changes
                        ForEach(comments, id: \.self) { comment in
                            
                            // Display the comment text
                            //\() is called interpolation in SwiftUI/Swift
                            Text("💬 \(comment)")
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)   // Update: Align bubble left
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)   // Update: Expand to screen width
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                )
                .padding(.horizontal)
                
                // Spacer pushes content upward and helps control layout spacing
                Spacer()
                
                
            }
            .padding()  //This is a modifier for the VStack
            
            
        }
    }
}

#Preview {
    ProfileView()
}
