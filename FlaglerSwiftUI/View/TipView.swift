// TipView.swift
// ─────────────────────────────────────────────────────
// LAYER:   View
// RULE:    SwiftUI layout only. No formulas. No business logic.
//          Calls vm.calculate() and vm.reset() — nothing else.
// Tip: This is your ConverterView.swift
// ─────────────────────────────────────────────────────

//  Last updated by Jeremy Wang on 4/1/26.


import SwiftUI   // Only the View imports SwiftUI

struct TipView: View {

  // @StateObject — this View owns the ViewModel.
  // Tip: @StateObject var vm = ConverterViewModel()
  @StateObject private var vm = TipViewModel()

  var body: some View {
      NavigationStack {  //This is not a layout tool. It manages a stack of screens that the user can push onto and pop off of — like the back button behavior you see in every iPhone app. Here's it's giving us the app title, which is tool. :)
          Form {  //Need the form wrap for getting user inputs! Make sure to include this for your converter app!

              // ─── Input section ────────────────────────────
              Section("Bill Details") {

                  // TextField bound to vm.billText with $ (two-way)
                  // Tip: TextField("Enter value", text: $vm.inputText)
                  TextField("Bill amount ($)", text: $vm.billText)
                      .keyboardType(.decimalPad)

                  // Picker bound to vm.tipPercent
                  // Tip: Picker("Category", selection: $vm.category)
                  Picker("Tip", selection: $vm.tipPercent) {
                      ForEach(vm.tipPresets, id: \.self) { pct in   //this is a temp variable representing any item
                          Text("\(Int(pct))%").tag(pct)
                          
                          //<option value="10">10 percentage</option>
                      }
                  }
                  //.pickerStyle()

                  // Toggle bound to vm.splitEvenly
                  // Tip: Toggle("Reverse", isOn: $vm.isReversed)
                  Toggle("Split the bill", isOn: $vm.splitEvenly)

                  if vm.splitEvenly {
                      Picker("People", selection: $vm.splitCount) {
                          ForEach(vm.splitOptions, id: \.self) { n in
                              Text("\(n) people").tag(n)
                          }
                      }
                  }
              }

              //─── Action buttons ───────────────────────────
              // Buttons call ViewModel methods — never do math here
              // Tip: Button("Convert") { vm.convert() }
              Section {
                  Button("Calculate") { vm.calculate() }
                      .frame(maxWidth: .infinity)
                  Button("Reset", role: .destructive) { vm.reset() }
                      .frame(maxWidth: .infinity)
              }

              // ─── Error feedback ───────────────────────────
              if let error = vm.errorMsg {
                  Section { Text(error).foregroundStyle(.red) }
              }

              // ─── Result display ───────────────────────────
              // View just reads pre-formatted strings from ViewModel.
              // Tip: Text(vm.resultText)
              Section("Result") {
                  LabeledContent("Tip",   value: vm.tipText)
                  LabeledContent("Total", value: vm.totalText)
                  LabeledContent("Each",  value: vm.eachText)
                      .bold()
              }
          }
          .navigationTitle("Tip Calculator")
          //.onChange(of: vm.tipPercent) {
          //vm.tipPercentChanged()
      }
  }
}
