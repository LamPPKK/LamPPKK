#if canImport(UIKit)
import UIKit
#endif
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif
import Foundation

func printSectionHeader(_ title: String) {
    print("\n" + String(repeating: "=", count: 70))
    print("📘 \(title)")
    print(String(repeating: "=", count: 70))
}

// ============================================================================
// MARK: - LESSON 01: VARIABLES, CONSTANTS & BASIC TYPES
// ============================================================================
/*:
 ## Lesson 01: Variables (`var`), Constants (`let`) & Basic Data Types
 - `let`: Declares a **constant** (cannot be reassigned). **Always prefer `let`** for safer and clearer code.
 - `var`: Declares a **variable** (value can change later).
 - Swift is **Type-Safe** (strict compile-time type checking) with **Type Inference** (automatically infers types from initial values).
 - **Important note**: Swift does NOT perform implicit numeric conversions between `Int` and `Double` — you must convert explicitly using `Double(intValue)`.
 */
printSectionHeader("LESSON 01: VARIABLES, CONSTANTS & BASIC TYPES")

// 1.1 Constants (let) and Variables (var) with Type Inference
let swiftReleaseYear = 2014        // Inferred as Int
var currentVersion = 6.0           // Inferred as Double
currentVersion = 6.2               // Valid because it is declared with `var`
// swiftReleaseYear = 2015         // Compile error if uncommented because `let` is immutable

// 1.2 Explicit Type Annotation
let languageName: String = "Swift"
let isOpenSource: Bool = true
let firstCharacter: Character = "S"
let gpaScore: Float = 3.85         // Float (32-bit); floating-point literals default to Double (64-bit)
let worldPopulationSample: Int = 100_000_000 // Underscores improve readability

// 1.3 Explicit Type Conversion
let basePrice: Int = 100
let taxAmount: Double = 8.5
let totalAmount: Double = Double(basePrice) + taxAmount

// 1.4 Type Alias
typealias Score = Double
let finalExamScore: Score = 9.5

print("Language: \(languageName) \(currentVersion), released in \(swiftReleaseYear), open source: \(isOpenSource)")
print("First char: \(firstCharacter) | Population: \(worldPopulationSample) | GPA: \(gpaScore) | Exam score: \(finalExamScore)")
print("Total amount after conversion: \(totalAmount)")

// MARK: Exercise 01
/*:
 ### 🎯 Exercise 01: Temperature Conversion & Rounding
 1. Declare a constant `celsius: Double = 32.5`.
 2. Compute Fahrenheit and store it in `fahrenheit` using: `F = C * 9 / 5 + 32`.
 3. Convert `fahrenheit` to an integer `roundedFahrenheit: Int` and print:
    `"32.5°C equals 90.5°F (truncated integer: 90°F)"`.
 */
// Write your solution for Exercise 01 here:
// let celsius: Double = 32.5
// ...
