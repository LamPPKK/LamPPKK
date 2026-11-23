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
// MARK: - LESSON 05: CONDITIONALS (IF, SWITCH & PATTERN MATCHING)
// ============================================================================
/*:
 ## Lesson 05: Conditionals (`if`, `switch` & Pattern Matching)
 - Conditions in `if` must evaluate strictly to `Bool`.
 - Since Swift 5.9+, `if` and `switch` can be used directly as **expressions** that return a value.
 - `switch` in Swift is powerful:
   - Must be **exhaustive** across all possible inputs.
   - **No implicit fallthrough** to the next case — `break` is not required.
   - Supports range matching (`80..<90`), tuple matching (`(x, y)`), value binding (`let x`), and `where` clauses.
 */
printSectionHeader("LESSON 05: CONDITIONALS & PATTERN MATCHING")

let temperatureCelsius = 28

// Using `if` as an expression
let weatherAdvice = if temperatureCelsius < 18 {
    "Cold weather, wear a jacket 🧥"
} else if temperatureCelsius <= 30 {
    "Pleasant mild weather 🌤️"
} else {
    "Hot sunny weather ☀️"
}
print("Temperature \(temperatureCelsius)°C -> \(weatherAdvice)")

// `switch` with Range Matching
let examPoint = 86
let academicRank = switch examPoint {
case 90...100: "Excellent"
case 80..<90:  "Good"
case 65..<80:  "Fair"
case 50..<65:  "Average"
case 0..<50:   "Weak"
default:       "Invalid Score"
}
print("Score \(examPoint) -> Rank: \(academicRank)")

// `switch` with Tuple + Value Binding + `where` clause
let coordinate = (x: 3, y: -3)
switch coordinate {
case (0, 0):
    print("At the origin (0, 0)")
case (let x, 0):
    print("On the x-axis at x = \(x)")
case (0, let y):
    print("On the y-axis at y = \(y)")
case let (x, y) where abs(x) == abs(y):
    print("Point (\(x), \(y)) lies on a diagonal line!")
case let (x, y):
    print("Arbitrary point at (\(x), \(y))")
}

// MARK: Exercise 05
/*:
 ### 🎯 Exercise 05: BMI Classification & Triangle Type
 1. Given `let weightKg = 68.0` and `let heightM = 1.72`, compute `bmi = weightKg / (heightM * heightM)`.
 2. Use a `switch` expression on `bmi` to assign `bmiCategory`:
    - `< 0` or `> 100`: `"Invalid"`
    - `0..<18.5`: `"Underweight"`
    - `18.5..<25.0`: `"Normal"`
    - `25.0..<30.0`: `"Overweight"`
    - `30.0...100`: `"Obese"`
 3. Use `switch` on a tuple `let sides = (a: 3, b: 4, c: 5)` with `where` clauses to classify equilateral, right, isosceles, or scalene triangles!
 */
// Write your solution for Exercise 05 here:
