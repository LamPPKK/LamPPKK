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
// MARK: - LESSON 08: FUNCTIONS
// ============================================================================
/*:
 ## Lesson 08: Functions (`func`)
 - Swift separates **Argument Labels** (used at the call site) from **Parameter Names** (used inside the function body), making calls read like natural English sentences.
 - Prefix a parameter with `_` to omit its argument label at the call site.
 - Functions support **Default Parameter Values**, **Variadic Parameters** (`Double...`), and returning multiple values via **Tuples**.
 - Parameters are constants (`let`) by default; use `inout` and `&` at the call site to mutate the caller's variable directly.
 */
printSectionHeader("LESSON 08: FUNCTIONS")

// Argument Labels (`from`, `to`) + Default Value (`transport`)
func findRoute(from origin: String, to destination: String, transport: String = "Motorbike") -> String {
    return "Route: \(origin) -> \(destination) by \(transport)"
}
print(findRoute(from: "Hanoi", to: "Ninh Binh"))
print(findRoute(from: "Ho Chi Minh City", to: "Vung Tau", transport: "Hydrofoil"))

// Omit Argument Label with `_` and return an Optional Tuple
func analyzeNumbers(_ numbers: [Int]) -> (min: Int, max: Int, sum: Int)? {
    guard let first = numbers.first else { return nil }
    var currentMin = first
    var currentMax = first
    var total = 0
    for number in numbers {
        if number < currentMin { currentMin = number }
        if number > currentMax { currentMax = number }
        total += number
    }
    return (currentMin, currentMax, total)
}

if let stats = analyzeNumbers([12, 5, 28, 9, 16]) {
    print("Array stats -> Min: \(stats.min), Max: \(stats.max), Sum: \(stats.sum)")
}

// Variadic Parameters (accepts zero or more arguments)
func calculateAverage(_ values: Double...) -> Double {
    guard !values.isEmpty else { return 0 }
    return values.reduce(0, +) / Double(values.count)
}
print("Average: \(calculateAverage(8.0, 9.0, 10.0))")

// `inout` parameters modify the original variables passed in
func swapValues(_ first: inout Int, _ second: inout Int) {
    let temp = first
    first = second
    second = temp
}
var leftNumber = 100
var rightNumber = 999
swapValues(&leftNumber, &rightNumber)
print("After swap (inout) -> leftNumber = \(leftNumber), rightNumber = \(rightNumber)")

// Function Types (Store functions in variables or pass them as arguments)
func multiply(_ a: Int, _ b: Int) -> Int { a * b }
let mathOperation: (Int, Int) -> Int = multiply
print("Called via Function Type variable: 6 * 7 = \(mathOperation(6, 7))")

// MARK: Exercise 08
/*:
 ### 🎯 Exercise 08: Electricity Invoice & Capped Bonus Points
 1. Write `calculateInvoice(for kwh: Int, unitPrice: Int = 3_000) -> (subtotal: Int, tax: Int, total: Int)` where:
    - `subtotal = kwh * unitPrice`
    - `tax = subtotal / 10` (10% VAT)
    - `total = subtotal + tax`
 2. Write `addBonusPoints(_ bonus: Int, to currentScore: inout Int)` that adds `bonus` to `currentScore`, capping the maximum score at `100`.
 */
// Write your solution for Exercise 08 here:
