//
//  ContentView.swift
//  FlaglerSwiftUI
//
//  Created by Jeremy Wang on 3/2/26.
//

import SwiftUI

struct CalculatorView: View {
    
    
    // The body property is required by the View protocol. It describes the UI layout for this view.
    var body: some View {
        //ZStack is a layered view container
        Text("Flagler Calculator")
            .font(Font.largeTitle)
            .bold(true)
            .foregroundColor(.gray)
    }
}

#Preview {
    CalculatorView()
}
