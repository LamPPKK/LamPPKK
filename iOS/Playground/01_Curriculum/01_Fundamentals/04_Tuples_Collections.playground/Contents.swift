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
// MARK: - LESSON 04: TUPLES & COLLECTION TYPES (ARRAY, SET, DICTIONARY)
// ============================================================================
/*:
 ## Lesson 04: Tuples & Collection Types (`Array`, `Set`, `Dictionary`)
 - **Tuple**: Groups multiple values (possibly of different types) into a single lightweight compound value.
 - **Array (`[Element]`)**: **Ordered** collection accessed by index `0..<count`; allows duplicate values.
 - **Set (`Set<Element>`)**: **Unordered** collection of **unique** elements with fast `O(1)` membership lookup.
 - **Dictionary (`[Key: Value]`)**: Key-value pairs with unique keys; key lookup returns an `Optional`.
 */
printSectionHeader("LESSON 04: TUPLES, ARRAYS, SETS & DICTIONARIES")

// 4.1 Tuple
let httpResponse = (statusCode: 200, message: "OK")
let (statusCode, _) = httpResponse // Tuple destructuring, ignoring message with `_`
print("Tuple -> Status: \(statusCode), Message: \(httpResponse.message)")

// 4.2 Array
var fruits: [String] = ["Apple", "Orange", "Mango"]
fruits.append("Grape")
fruits.insert("Strawberry", at: 1)
let removedFruit = fruits.removeLast()
print("Array -> \(fruits) (Removed: \(removedFruit), Count: \(fruits.count))")

// 4.3 Set (Automatically removes duplicates & supports set algebra)
let rawTags = ["swift", "ios", "xcode", "swift", "ios"]
var uniqueTags = Set(rawTags)
uniqueTags.insert("swiftui")

let groupA: Set<Int> = [1, 2, 3, 4]
let groupB: Set<Int> = [3, 4, 5, 6]
print("Unique Set: \(uniqueTags.sorted())")
print("Intersection: \(groupA.intersection(groupB).sorted()) | Union: \(groupA.union(groupB).sorted())")

// 4.4 Dictionary
var studentScores: [String: Int] = [
    "Alice": 85,
    "Bob": 92
]
studentScores["Charlie"] = 78               // Insert
studentScores["Alice"] = 88                 // Update
let bobScore = studentScores["Bob", default: 0]
let missingScore = studentScores["David", default: 0]
print("Dictionary -> Bob's score: \(bobScore), David's score (default): \(missingScore)")

// MARK: Exercise 04
/*:
 ### 🎯 Exercise 04: Shopping Cart Frequency Analysis
 Given an array of selected SKUs (with duplicates for multiple quantities):
 `let selectedSKUs = ["SKU01", "SKU02", "SKU01", "SKU03", "SKU02", "SKU01"]`
 And a price catalog:
 `let priceCatalog: [String: Int] = ["SKU01": 120_000, "SKU02": 250_000, "SKU03": 90_000]`
 **Requirements**:
 1. Use a `Set` to count how many **distinct product types** were selected.
 2. Build a dictionary `itemQuantities: [String: Int]` counting how many times each SKU appears (e.g., `["SKU01": 3, ...]`).
    *(Hint: iterate over the array and use `itemQuantities[sku, default: 0] += 1`)*.
 */
// Write your solution for Exercise 04 here:
