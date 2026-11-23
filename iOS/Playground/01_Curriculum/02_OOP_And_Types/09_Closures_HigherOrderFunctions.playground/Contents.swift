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
// MARK: - LESSON 09: CLOSURES & HIGHER-ORDER FUNCTIONS
// ============================================================================
/*:
 ## Lesson 09: Closures & Higher-Order Functions
 - A **Closure** is a self-contained block of functionality that can be stored in variables, passed into functions, and **capture** references to values from its surrounding scope.
 - Shorthand syntax: `{ (a: String, b: String) -> Bool in return a < b }` -> `{ $0 < $1 }` + **Trailing Closure**.
 - **`@escaping`**: Marks a closure that outlives the function call (commonly used for async callbacks and stored handlers).
 - **Essential Higher-Order Functions**:
   - `map`: Transforms every element to a new value/type (preserves count).
   - `compactMap`: Transforms elements and **automatically removes `nil` results**.
   - `flatMap`: Flattens nested collections `[[Element]]` into `[Element]`.
   - `filter`: Keeps only elements matching a `Bool` predicate.
   - `reduce`: Combines all elements into a single accumulated value.
 */
printSectionHeader("LESSON 09: CLOSURES & HIGHER-ORDER FUNCTIONS")

let developerNames = ["Tuan", "An", "Binh", "Dung"]

// Full syntax vs Shorthand with Trailing Closure & Shorthand Arguments ($0, $1)
let sortedAscending = developerNames.sorted(by: { (lhs: String, rhs: String) -> Bool in
    return lhs < rhs
})
let sortedDescending = developerNames.sorted { $0 > $1 }
print("Ascending: \(sortedAscending) | Descending: \(sortedDescending)")

// Capturing Values
func makeStepCounter(step: Int) -> () -> Int {
    var runningTotal = 0
    return {
        runningTotal += step // `runningTotal` is captured and retained by the closure
        return runningTotal
    }
}
let incrementByTen = makeStepCounter(step: 10)
print("Capture Value -> Call 1: \(incrementByTen()), Call 2: \(incrementByTen())")

// @escaping Closure
func fetchRemoteConfig(completion: @escaping (String) -> Void) {
    completion("Remote config loaded successfully!")
}
fetchRemoteConfig { responseMessage in
    print("@escaping -> \(responseMessage)")
}

// Comparing `map`, `compactMap`, and `flatMap`
let rawStrings: [String] = ["1", "2", "3", "4", "car"]
let mappedInts: [Int?] = rawStrings.map { Int($0) }               // Keeps nil -> [Optional(1), ..., nil]
let validInts: [Int] = rawStrings.compactMap { Int($0) }          // Filters out nil -> [1, 2, 3, 4]

let nestedArrays: [[Int]] = [[1, 2], [3], [4, 5]]
let flattenedInts: [Int] = nestedArrays.flatMap { $0 }            // Flattens -> [1, 2, 3, 4, 5]

// Chaining: filter -> map -> reduce
let sumOfEvenSquares = validInts
    .filter { $0.isMultiple(of: 2) }   // [2, 4]
    .map { $0 * $0 }                   // [4, 16]
    .reduce(0, +)                      // 20

print("map (contains Optional): \(mappedInts.map { String(describing: $0) })")
print("compactMap (non-nil Ints): \(validInts)")
print("flatMap (flattened 2D array): \(flattenedInts)")
print("filter + map + reduce (sum of even squares): \(sumOfEvenSquares)")

// MARK: Exercise 09
/*:
 ### 🎯 Exercise 09: Process Raw CSV Grades with Higher-Order Functions
 Given a grade list containing invalid entries:
 `let rawCSVGrades = ["8.5", "absent", "4.0", "9.2", "6.5", "N/A", "7.8", "3.5"]`
 **Requirements (do NOT use `for` loops)**:
 1. Use `compactMap` to convert valid strings into `validGrades: [Double]`.
 2. Use `filter` and `sorted` to build `passingGrades` containing grades `>= 5.0` sorted in **descending** order.
 3. Use `reduce` to calculate the average of `passingGrades`.
 */
// Write your solution for Exercise 09 here:
