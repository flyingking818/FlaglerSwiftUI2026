//
//  CalculatorView.swift
//
// Created by Jeremy Wang on 2/25/26.
//

import SwiftUI

// MARK: - Theme Model
// This enum defines the two calculator themes we want to support.
// CaseIterable allows us to loop through all theme options in the Picker.
enum CalculatorTheme: String, CaseIterable {
    case apple = "Apple"
    case flagler = "Flagler"
}

// MARK: - Theme Colors
// This structure groups all colors needed for a calculator theme.
// Using a theme model makes the code easier to maintain and scale.
struct ThemeColors {
    let background: Color
    let displayText: Color
    let formulaText: Color
    let operatorButton: Color
    let controlButton: Color
    let numberButton: Color
}

// MARK: - Flagler College Colors
extension Color {
    static let flaglerCrimson = Color(red: 0.6, green: 0.0, blue: 0.1)
    static let flaglerGold = Color(red: 0.9, green: 0.7, blue: 0.2)
    static let flaglerDarkCrimson = Color(red: 0.45, green: 0.0, blue: 0.08)
    static let flaglerCharcoal = Color(red: 0.18, green: 0.18, blue: 0.2)
}

// CalculatorView is the main screen for our calculator.
// This example demonstrates several core SwiftUI concepts we discuss in class,
// including state management, layout containers, and modifier chaining.
struct CalculatorView: View {
    // MARK: - State Variables
    // @State tells SwiftUI that these variables can change during runtime.
    // When their values change, SwiftUI automatically redraws the interface.
    //@State is a property wrapper in SwiftUI.
    //It is used for local, view-owned data
    //"When this changes, update the screen automatically."
    //This pattern is called state-driven UI:
    //You don't manually update UI elements
    //You update data, and SwiftUI updates the UI for you
    // This is a key concept in modern declarative UI frameworks.

    // The text currently displayed on the calculator screen
    @State private var display = "0"

    // Shows the current formula above the main display (e.g. "2 + 3 ×")
    @State private var formulaText = ""

    // MARK: - Chained Calculation State
    // expressionTokens stores the full sequence of numbers and operators
    // entered so far, for example: ["2", "+", "3", "×"]
    // Using an array of tokens lets us support chained operations across
    // multiple operators without losing earlier parts of the expression.
    // This replaces the previous single runningValue + operation approach.
    @State private var expressionTokens: [String] = []

    // Tracks whether the user is starting to type a new number.
    // Prevents digits from incorrectly appending to previous numbers.
    @State private var isNewNumber = true

    // Stores the currently selected calculator theme
    @State private var selectedTheme: CalculatorTheme = .apple

    // Tracks whether the last button pressed was "=".
    // Used to decide whether a new digit clears the expression (fresh start)
    // or a new operator continues chaining from the result.
    @State private var justCalculated = false

    // MARK: - Button Layout
    // A two dimensional array representing the layout of the calculator buttons.
    // Each inner array represents one row of buttons.
    // This approach allows us to dynamically generate the interface using loops.
    private let buttons: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]

    // MARK: - Current Theme
    // Returns the appropriate color palette based on the selected theme.
    var currentTheme: ThemeColors {
        switch selectedTheme {
        case .apple:
            return ThemeColors(
                background: .black,
                displayText: .white,
                formulaText: .gray,
                operatorButton: .orange,
                controlButton: Color.gray.opacity(0.8),
                numberButton: Color(white: 0.2)
            )
        case .flagler:
            return ThemeColors(
                background: .flaglerCrimson,
                displayText: .white,
                formulaText: Color.white.opacity(0.8),
                operatorButton: .flaglerGold,
                controlButton: .flaglerDarkCrimson,
                numberButton: .flaglerCharcoal
            )
        }
    }

    // MARK: - Main User Interface
    // The body property defines the entire user interface.
    // SwiftUI uses a declarative approach: we describe WHAT the UI should look like
    // instead of writing step by step instructions for drawing it.
    var body: some View {
        // ZStack allows views to be layered on top of each other.
        // Here we place the calculator interface on top of a background.
        ZStack {
            // Background color covering the entire screen
            currentTheme.background.ignoresSafeArea()

            // VStack arranges elements vertically.
            VStack(spacing: 12) {
                // MARK: - Theme Picker
                // Picker allows the user to switch between the Apple and Flagler themes.
                Picker("Theme", selection: $selectedTheme) {
                    ForEach(CalculatorTheme.allCases, id: \.self) { theme in
                        Text(theme.rawValue).tag(theme)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer()

                // MARK: - Display Screen
                // HStack arranges elements horizontally.
                // The Spacer pushes the display text to the right side
                // similar to the Apple iPhone calculator.
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 6) {
                        // Formula line: shows the running expression above the result,
                        // e.g. "2 + 3 ×" while typing, or "2 + 3 × 4 =" after pressing equals.
                        Text(formulaText)
                            .foregroundColor(currentTheme.formulaText)
                            .font(.system(size: 24, weight: .regular))
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)

                        // Main result display — large number at the bottom of the display area
                        Text(display)
                            .foregroundColor(currentTheme.displayText)
                            .font(.system(size: 64, weight: .light))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    .padding(.horizontal)
                }

                // MARK: - Generate Button Grid
                // ForEach allows us to dynamically generate UI elements.
                // Instead of manually writing every button,
                // we loop through the array of button labels.
                // This technique is widely used in modern UI development.
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        // Loop through each button in the row
                        ForEach(row, id: \.self) { item in
                            // Build a calculator button using our helper function
                            calculatorButton(for: item)
                        }
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Button View Builder
    // This helper function builds a calculator button.
    // @ViewBuilder allows the function to return SwiftUI views.
    // We use this to avoid repeating the same button code multiple times.
    @ViewBuilder
    func calculatorButton(for item: String) -> some View {
        Button(action: {
            // When a button is pressed,
            // send the button label to the logic handler
            buttonTapped(item)
        }) {
            Text(item)
                .font(.system(size: 32))
                .foregroundColor(textColor(for: item))
                // Apple calculator uses a wider "0" button
                .frame(width: item == "0" ? 172 : 80, height: 80)
                // Background color depends on button type
                .background(buttonColor(for: item))
                // Capsule creates the rounded button shape
                .clipShape(Capsule())
        }
    }

    // MARK: - Button Color Logic
    // Determines the color of each button.
    // Operators use the theme operator color,
    // top controls use the theme control color,
    // numbers use the theme number color.
    func buttonColor(for item: String) -> Color {
        if ["÷", "×", "-", "+", "="].contains(item) {
            return currentTheme.operatorButton
        } else if ["AC", "+/-", "%"].contains(item) {
            return currentTheme.controlButton
        } else {
            return currentTheme.numberButton
        }
    }

    func textColor(for item: String) -> Color {
        if ["÷", "×", "-", "+", "="].contains(item) && selectedTheme == .flagler {
            return .black
        } else {
            return .white
        }
    }

    // MARK: - Formatting Helpers
    // Formats numbers to remove unnecessary decimals.
    // For example, 4.0 becomes "4" but 4.5 stays "4.5".
    func formatNumber(_ number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(number))
        } else {
            return String(number)
        }
    }

    // Returns the numeric value currently shown on the display.
    func currentDisplayValue() -> Double {
        Double(display) ?? 0
    }

    // MARK: - Single Operation Helper
    // Applies a single binary operation between two numbers.
    // Used by evaluateExpression() when processing each operator in the chain.
    // leftHandSide + rightHandSide = result :)
    func applyOperation(_ lhs: Double, _ rhs: Double, op: String) -> Double {
        switch op {
        case "+": return lhs + rhs
        case "-": return lhs - rhs
        case "×": return lhs * rhs
        case "÷": return rhs == 0 ? 0 : lhs / rhs
        default:  return rhs
        }
    }

    // MARK: - Expression Evaluator (Order of Operations)
    // Evaluates the full token array respecting standard math precedence:
    // A token is just a single meaningful chunk of something larger.
    
    // Therefore, in our case, multiplication and division are applied before addition and subtraction.
    // For example, here we want the calculator to do something like this
    // - turn a token array like ["2", "+", "3", "×", "4"] into 14.0 — correctly, respecting order of operations.
    
    // Algorithm (two-pass):
    //   Pass 1 — process all × and ÷ left to right, collapsing each
    //           pair of adjacent values into a single number and
    //           removing the consumed operator from ops.
    //   Pass 2 — process all remaining + and − left to right.
    //
    // In simple terms:
    // Pass 1 says: find any × or ÷ and solve it immediately
    // You scan left to right. You find 3 × 4. You solve it: 12. Now you cross out 3 × 4 and write 12 in its place:
    //  2  +  12
    //  The × is gone. The 3 and 4 are gone. They got collapsed into one number.
    
    // Example token sequence before equals: ["2", "+", "3", "×", "4"]
    //   Pass 1 result: ["2", "+", "12"]   (3 × 4 collapsed first)
    //   Pass 2 result: 14                 (2 + 12)
   
  
    func evaluateExpression(_ tokens: [String]) -> Double {
        // Convert token strings into a mixed array of Doubles and operator strings.
        // Numbers become Double values; operators stay as String.
        var values: [Double] = []
        var ops: [String] = []

        for token in tokens {
            if let num = Double(token) {
                values.append(num)
            } else {
                ops.append(token)
            }
        }
        //fo example, here we got
        //values → [2,  3,  4]
        //ops    → ["+", "×"]
        

        // Guard: we need at least one value to work with
        guard !values.isEmpty else { return 0 }

        // Pass 1 — handle × and ÷ first (higher precedence)
        var i = 0
        while i < ops.count {
            let op = ops[i]
            if op == "×" || op == "÷" {
                // Combine values[i] and values[i+1] using this operator
                let result = applyOperation(values[i], values[i + 1], op: op)
                // Replace the two values with their result
                values.replaceSubrange(i...i+1, with: [result])
                // Remove the consumed operator
                ops.remove(at: i)
                // Do not advance i — the new merged value is now at position i
            } else {
                i += 1
            }
        }
        /*here, the process is like this:
        Start at position 0 and scan through `ops`:

        i=0: op is "+" → not × or ÷ → skip, move to i=1

        i=1: op is "×" → solve it!
        - call the applyOperation(3, 4, op: "×") → 12
        - replace 3 and 4 with 12 in values
        - delete "×" from ops
        
        values → [2,  12]
        ops    → ["+"]
        */
                

        // Pass 2 — handle + and − (lower precedence), left to right
        var result = values[0]
        for j in 0..<ops.count {
            result = applyOperation(result, values[j + 1], op: ops[j])
        }

        return result
    }

    // MARK: - Button Action Logic
    // This function handles what happens when any button is pressed.
    // It processes numbers, operations, and calculator functions.
    func buttonTapped(_ value: String) {
        switch value {

        // MARK: - Number Input
        case "0","1","2","3","4","5","6","7","8","9":
            if justCalculated {
                // After "=", a digit press starts a brand new expression.
                // The previous result is discarded entirely.
                expressionTokens = []
                formulaText = ""
                justCalculated = false
            }
            if isNewNumber {
                // Replace the display value when starting a new number
                display = value
                isNewNumber = false
            } else {
                // Otherwise append the digit to what is already shown
                // This is a ternary operator — a compact if/else squeezed into one line. Similar to the C# we learned in CIS 205/305
                // condition ? valueIfTrue : valueIfFalse
                display = display == "0" ? value : display + value
            }

        // MARK: - Decimal Point
        case ".":
            if justCalculated {
                // After "=", a decimal starts fresh (e.g. "0.")
                expressionTokens = []
                formulaText = ""
                justCalculated = false
            }
            if isNewNumber {
                display = "0."
                isNewNumber = false
            } else if !display.contains(".") {
                display += "."
            }

        // MARK: - Operation Buttons (+, -, ×, ÷)
        // When the user taps an operator:
        //   1. Append the current display number to expressionTokens.
        //   2. Append the operator to expressionTokens.
        //   3. Evaluate and show the running total on the display.
        //   4. Update formulaText to mirror the full expression so far.
        //
        // If the user taps a second operator without entering a new number,
        // we simply replace the last operator in the token array.
        case "+", "-", "×", "÷":
            if justCalculated {
                // After "=", tapping an operator continues chaining
                // from the result — do NOT clear the expression.
                // expressionTokens already contains the result as a single token
                // from the "=" handler below.
                justCalculated = false
            }

            if isNewNumber && !expressionTokens.isEmpty {
                // User tapped operator twice (or changed operator).
                // Replace the last operator token instead of adding a new one.
                expressionTokens[expressionTokens.count - 1] = value
            } else {
                // Commit the current display value into the token list
                expressionTokens.append(display)
                // Append the new operator
                expressionTokens.append(value)

                // Evaluate the expression so far (everything except the
                // just-added trailing operator) to show a running total.
                // This matches Apple Calculator behavior: the display updates
                // after each operator tap to show intermediate results.
                let tokensToEval = expressionTokens.dropLast() // drop trailing operator
                let runningResult = evaluateExpression(Array(tokensToEval))
                display = formatNumber(runningResult)
                isNewNumber = true
            }

            // Build the formula text by joining all tokens with spaces.
            // This is what appears in the smaller line above the result.
            formulaText = expressionTokens.joined(separator: " ")

        // MARK: - Equals Calculation
        // When "=" is pressed:
        //   1. Append the current display value to finalize the expression.
        //   2. Evaluate the complete token array (with operator precedence).
        //   3. Show the full expression with "=" in the formula line.
        //   4. Display the final result.
        case "=":
            // Need at least one operator in the list to calculate
            guard expressionTokens.count >= 2 else { return }

            // If isNewNumber is true the user tapped "=" right after another operator —
            // in that case re-use the last number already committed.
            if !isNewNumber {
                expressionTokens.append(display)
            }

            // Build the formula display: "2 + 3 × 4 ="
            formulaText = expressionTokens.joined(separator: " ") + " ="

            // Evaluate the full expression with correct operator precedence
            let result = evaluateExpression(expressionTokens)
            display = formatNumber(result)

            // Store the result as the sole token so chaining after "=" works:
            // e.g. the user can press "+" next and continue from this result.
            expressionTokens = [formatNumber(result)]
            isNewNumber = true
            justCalculated = true

        // MARK: - Clear Button
        // AC resets everything back to the initial state.
        case "AC":
            display = "0"
            formulaText = ""
            expressionTokens = []
            isNewNumber = true
            justCalculated = false

        // MARK: - Change Sign
        case "+/-":
            if let number = Double(display) {
                display = formatNumber(number * -1)
            }

        // MARK: - Percent
        case "%":
            if let number = Double(display) {
                display = formatNumber(number / 100)
            }

        default:
            break
        }
    }
}

// MARK: - Preview
#Preview {
    CalculatorView()
}
