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
// MARK: - LESSON 06: LOOPS & CONTROL TRANSFER
// ============================================================================
/*:
 ## Lesson 06: Loops (`for-in`, `while`, `repeat-while`) & Control Transfer
 - `for-in`: Iterates over ranges, arrays, dictionaries, and strings. Combine with `.enumerated()` to get `(index, element)`.
 - `stride(from:to:by:)` / `stride(from:through:by:)`: Loops with custom step sizes.
 - `while`: Evaluates the condition before each iteration.
 - `repeat-while`: Executes the loop body **at least once** before checking the condition.
 - `continue` (skip current iteration), `break` (exit loop), and **Labeled Statements** (`outerLoop:`) to exit nested loops cleanly.
 */
printSectionHeader("LESSON 06: LOOPS & CONTROL TRANSFER")

let fruits = ["Apple", "Strawberry", "Orange", "Mango"]
for (index, fruit) in fruits.enumerated() {
    print("  [\(index)] \(fruit)")
}

var evenNumbers: [Int] = []
for number in stride(from: 2, through: 10, by: 2) {
    evenNumbers.append(number)
}
print("Even numbers with stride: \(evenNumbers)")

var countdown = 3
while countdown > 0 {
    countdown -= 1
}

var connectionAttempts = 0
repeat {
    connectionAttempts += 1
} while connectionAttempts < 1
print("Minimum connection attempts (repeat-while): \(connectionAttempts)")

// Labeled Statement: Exit both nested loops immediately when the target is found
let numberMatrix = [[1, 2, 3], [4, 99, 6], [7, 8, 9]]
outerLoop: for (rowIndex, row) in numberMatrix.enumerated() {
    for (colIndex, value) in row.enumerated() {
        if value == 99 {
            print("Found 99 at row \(rowIndex), column \(colIndex) -> Breaking outerLoop!")
            break outerLoop
        }
    }
}

// MARK: Exercise 06
/*:
 ### 🎯 Exercise 06: FizzBuzz & Prime Number Search
 1. Loop through numbers `1` to `20`:
    - Divisible by both `3` and `5`: append `"FizzBuzz"` to `fizzBuzzResults: [String]`
    - Divisible by `3` only: append `"Fizz"`
    - Divisible by `5` only: append `"Buzz"`
    - Otherwise: append `"\(number)"`.
 2. Use a `while` loop to find the **first prime number greater than 50** (expected result: `53`).
 */
// Write your solution for Exercise 06 here:
