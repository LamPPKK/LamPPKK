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
// MARK: - LESSON 07: OPTIONALS — SAFE NIL HANDLING
// ============================================================================
/*:
 ## Lesson 07: Optionals (`T?`)
 Regular variables in Swift can **never hold `nil`**. When a value may be absent, declare it as an Optional using `?` (e.g., `String?`, `Int?`).

 ### 4 Safe Ways to Unwrap Optionals:
 1. `if let`: Unwraps locally inside the `if` scope (supports shorthand `if let value { ... }` since Swift 5.7+).
 2. `guard let ... else { return }`: Validates preconditions at the top of a function (**Early Exit**), avoiding deeply nested `if` statements.
 3. `??` (**Nil-Coalescing**): Provides a fallback default value if the optional is `nil`.
 4. `?.` (**Optional Chaining**): Safely accesses nested properties/methods (returns `nil` if any link in the chain is `nil`).
 > ⚠️ **Golden Rule**: Avoid Force Unwrap (`!`). Using `!` on `nil` crashes the application immediately.
 */
printSectionHeader("LESSON 07: OPTIONALS")

let portString = "8080"
let parsedPort: Int? = Int(portString) // Int("abc") returns nil, so the type is Int?

// 1. Shorthand Optional Binding (`if let parsedPort`)
if let parsedPort {
    print("if let -> Successfully unwrapped network port: \(parsedPort)")
}

// 2. Early Exit with `guard let`
func greetMember(username: String?, age: Int?) {
    guard let username, !username.isEmpty else {
        print("guard let -> Error: Username is empty or nil!")
        return
    }
    let ageDescription = age.map { "\($0) years old" } ?? "age not provided"
    print("guard let -> Hello \(username) (\(ageDescription))!")
}

greetMember(username: nil, age: 21)
greetMember(username: "minh_dev", age: 21)

// 3. Optional Chaining (`?.`)
struct Address {
    var city: String
}
struct Company {
    var headquarters: Address?
}
struct Developer {
    var name: String
    var company: Company?
}

let juniorDev = Developer(name: "Lan", company: Company(headquarters: Address(city: "Da Nang")))
let workingCity = juniorDev.company?.headquarters?.city ?? "Remote"
print("Optional Chaining -> \(juniorDev.name)'s work location: \(workingCity)")

// MARK: Exercise 07
/*:
 ### 🎯 Exercise 07: Registration Form Age Validation
 Write `validateAge(input: String?) -> Int?` using `guard let` to enforce:
 1. `input` is non-nil and non-empty after trimming whitespace.
 2. It converts cleanly to `Int`.
 3. The age value is within the valid range `13...120`.
 Return `nil` if any check fails; otherwise return the validated `Int`.
 Test with `nil`, `"   "`, `"twenty"`, `"10"`, and `"24"`.
 */
// Write your solution for Exercise 07 here:
// func validateAge(input: String?) -> Int? {
//     ...
// }
