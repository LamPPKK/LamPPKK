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
// MARK: - LESSON 16: ERROR HANDLING (`throws`, `defer`, `Result`)
// ============================================================================
/*:
 ## Lesson 16: Error Handling (`throws`, `do-try-catch`, `try?`, `defer`, `Result`)
 - Define explicit error sets using an `enum` conforming to `Error`.
 - Mark throwing functions with `throws` and raise errors with `throw`.
 - Handle errors explicitly with `do { try ... } catch ...`, or convert errors to `nil` with `try?`.
 - **`defer`**: Guarantees cleanup code **always executes before leaving the current scope** (whether returning normally or throwing) — ideal for closing files, releasing locks, or cleaning up resources.
 - **`Result<Success, Failure>`**: Encapsulates either a success value or an error in a single return value.
 */
printSectionHeader("LESSON 16: ERROR HANDLING, DEFER & RESULT")

extension Int {
    var formattedVND: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let numberText = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(numberText) VND"
    }
}

enum ATMError: Error {
    case invalidMultiple
    case insufficientFunds(shortfall: Int)
}

func withdrawCash(amount: Int, from balance: inout Int) throws -> String {
    defer {
        print("  [defer] Transaction session ended -> Returning ATM card to customer.")
    }

    guard amount > 0 && amount.isMultiple(of: 50_000) else {
        throw ATMError.invalidMultiple
    }
    guard amount <= balance else {
        throw ATMError.insufficientFunds(shortfall: amount - balance)
    }

    balance -= amount
    return "Withdrew \(amount.formattedVND). Remaining balance: \(balance.formattedVND)"
}

var accountBalance = 500_000
do {
    let receipt = try withdrawCash(amount: 200_000, from: &accountBalance)
    print("Success -> \(receipt)")
    _ = try withdrawCash(amount: 400_000, from: &accountBalance) // Intentionally exceed balance
} catch ATMError.invalidMultiple {
    print("Caught error -> Withdrawal amount must be a multiple of 50,000 VND!")
} catch ATMError.insufficientFunds(let shortfall) {
    print("Caught error -> Insufficient funds, short by \(shortfall.formattedVND)!")
} catch {
    print("Unexpected error: \(error)")
}

// Using `Result<Success, Failure>`
enum MathError: Error {
    case divisionByZero
}

func divide(_ numerator: Double, by denominator: Double) -> Result<Double, MathError> {
    guard denominator != 0 else { return .failure(.divisionByZero) }
    return .success(numerator / denominator)
}

switch divide(10, by: 4) {
case .success(let quotient): print("Result success -> 10 / 4 = \(quotient)")
case .failure(let error):    print("Result failure -> \(error)")
}

// MARK: Exercise 16
/*:
 ### 🎯 Exercise 16: Password Strength Validator (`PasswordError`)
 1. Define `enum PasswordError: Error` with:
    - `.tooShort(minimumLength: Int)`
    - `.containsWhitespace`
    - `.missingDigit`
 2. Write `func validatePassword(_ password: String) throws -> Bool`:
    - At least `8` characters (otherwise throw `.tooShort(minimumLength: 8)`).
    - No spaces `" "` (otherwise throw `.containsWhitespace`).
    - Contains at least one digit (`password.contains(where: \.isNumber)` — otherwise throw `.missingDigit`).
 3. Use `do-try-catch` to test `"12345"`, `" mypass123"`, `"abcdefgh"`, and `"Swift2026"`.
 */
// Write your solution for Exercise 16 here:
