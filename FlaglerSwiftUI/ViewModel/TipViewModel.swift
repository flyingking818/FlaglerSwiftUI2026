//
//  TipViewModel.swift
//  FlaglerSwiftUI
//
//  Last Updated by Jeremy Wang on 4/1/26.
//

// ─────────────────────────────────────────────────────
// LAYER:   ViewModel
// RULE:    No UI layout. Owns @Published state.
//          Calls Model. Formats results as Strings.
// Tip: This is your ConverterViewModel.swift
// ─────────────────────────────────────────────────────

import Foundation
import Combine

// @MainActor keeps UI updates on the main thread (safe practice)
@MainActor
class TipViewModel: ObservableObject {

   // ─── @Published state ─────────────────────────────────
   // Every property here has a matching UI control in the View.
   // When any @Published property changes, SwiftUI rebuilds the View.
   // Tip: mirrors @Published vars in ConverterViewModel

   @Published var billText:    String = ""       // ← TextField
   @Published var tipPercent:  Double = 18.0    // ← Picker (tip %)
   @Published var splitCount:  Int    = 1        // ← Picker (people)
   @Published var splitEvenly: Bool   = false   // ← Toggle

   // Output — formatted strings the View displays directly
   @Published var tipText:    String  = "—"
   @Published var totalText:  String  = "—"
   @Published var eachText:   String  = "—"
   @Published var errorMsg:   String? = nil

   // ─── Computed property for the Picker ─────────────────
   // Tip: Your availableUnits computed property in the converter app.
   var tipPresets: [Double]  { TipModel.tipPresets }
   var splitOptions: [Int]  { TipModel.splitOptions }

   // ─── Action: user tapped "Calculate" ──────────────────
   // Tip: Your convert() function
   // Pattern: validate → call Model → format output
   func calculate() {
       errorMsg = nil

       // Step 1 — Validate: is the input a real number?
       guard let bill = Double(billText), bill > 0 else {
           errorMsg = "Please enter a valid bill amount."
           return
       }

       // Step 2 — Call the Model. The ViewModel never does math.
       let result = TipModel.calculate(
           bill:       bill,
           tipPercent: tipPercent,
           splitBy:    splitEvenly ? splitCount : 1 //?Ternery operator - similar to if(logical_test, if_yes, if_no)
       )

       // Step 3 — Format results for display (2 decimal places)
       // Tip: String(format: "%.2f %@", result, toUnit)
       tipText   = String(format: "$%.2f", result.tipAmount)
       totalText = String(format: "$%.2f", result.totalAmount)
       eachText  = splitEvenly
           ? String(format: "$%.2f each", result.amountEach)
           : totalText
   }

   // ─── Acton: user tapped "Reset" ──────────────────────
   // Tip: Your reset() function — clears all @Published state
   func reset() {
       billText    = ""
       tipPercent  = 18.0
       splitCount  = 1
       splitEvenly = false
       tipText     = "—"
       totalText   = "—"
       eachText    = "—"
       errorMsg    = nil
   }
}
