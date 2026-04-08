//
//  TipModel.swift
//  FlaglerSwiftUI
//
//  Last updated by Jeremy Wang on 4/1/26.
//

import Foundation   //  import SwiftUI ← NEVER in the Model

struct TipModel {

  // Result is a plain data container — no UI attached.
  // Tip: In your Converter app this could be a Double or a custom struct.
  struct Result {
      let tipAmount:    Double  // e.g. 9.00
      let totalAmount:  Double  // e.g. 59.00
      let amountEach:   Double  // e.g. 19.67 when split 3 ways
  }

  // ─── Main calculation function ───────────────────────
  // The ViewModel calls ONLY this function.
  // Notice: takes plain Swift types, returns a plain struct.
  // Tip: Your ConverterModel.convert(_:from:to:category:)
  
  static func calculate(
      bill:       Double,   // raw bill total, e.g. 50.00
      tipPercent: Double,   // e.g. 18.0 (for 18%)
      splitBy:    Int       // number of people splitting the bill
  ) -> Result {

      // Step 1 — compute the tip dollar amount
      let tipAmount   = bill * (tipPercent / 100.0)

      // Step 2 — add tip to the original bill
      let totalAmount = bill + tipAmount

      // Step 3 — divide among the party
      //max() is a built-in Swift function that returns whichever of the two numbers is larger.
      //So here, it basically means: give me splitBy, but never let it go below 1. So at least, we've got one person to pay the bill! :)
      // Guard against divide-by-zero: set splitBy to minimum 1
      let people      = max(1, splitBy)
      let amountEach  = totalAmount / Double(people)

      // Return the data bundle (an object). ViewModel will format it
      // So you can expand on this as you see fit. Think about how to use this for your converter app.
      return Result(
          tipAmount:   tipAmount,
          totalAmount: totalAmount,
          amountEach:  amountEach
      )
  }

  // ─── Supported tip presets ────────────────────────────
  // Tip: Your ConverterModel.units(for:) array  - we need to make this conditional! :) switch...case, or if...else if
  // The View's Picker reads this list — Model owns the data.
  static let tipPresets: [Double] = [10, 15, 18, 20, 25]
  static let splitOptions: [Int]   = [1, 2, 3, 4, 5, 6]
}
