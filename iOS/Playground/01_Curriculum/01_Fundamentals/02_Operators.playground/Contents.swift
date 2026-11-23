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
// MARK: - LESSON 02: OPERATORS
// ============================================================================
/*:
 ## Lesson 02: Basic & Advanced Operators
 - **Arithmetic**: `+`, `-`, `*`, `/`, `%` (remainder for integers).
 - **Compound Assignment**: `+=`, `-=`, `*=`, `/=`.
 - **Comparison**: `==`, `!=`, `>`, `<`, `>=`, `<=`.
 - **Logical**: `!` (NOT), `&&` (AND), `||` (OR).
 - **Ternary Conditional**: `condition ? valueIfTrue : valueIfFalse`.
 - **Nil-Coalescing (`??`)**: `optionalValue ?? fallbackValue` (returns fallback when `nil`).
 - **Ranges**: `a...b` (Closed: includes a and b), `a..<b` (Half-open: from a up to but not including b), `...b` / `a...` (One-sided).
 */
printSectionHeader("LESSON 02: OPERATORS")

let dividend = 17
let divisor = 5
print("17 / 5 = \(dividend / divisor) (integer division), 17 % 5 = \(dividend % divisor) (remainder)")

var rewardPoints = 10
rewardPoints += 5

let customerAge = 20
let hasStudentID = false
let isEligibleForDiscount = (customerAge < 18) || hasStudentID
let ticketCategory = customerAge >= 18 ? "Adult Ticket" : "Child Ticket"

let nicknameInput: String? = nil
let displayName = nicknameInput ?? "Guest"

let closedRange = 1...5       // 1, 2, 3, 4, 5
let halfOpenRange = 1..<5     // 1, 2, 3, 4

print("Reward points: \(rewardPoints) | Discount eligible: \(isEligibleForDiscount) | Ticket: \(ticketCategory)")
print("Display name: \(displayName) | Is 5 in 1..<5? \(halfOpenRange.contains(5)), in 1...5? \(closedRange.contains(5))")

// MARK: Exercise 02
/*:
 ### 🎯 Exercise 02: Shipping Fee & Coupon Calculation
 Given:
 - `orderSubtotal: Double = 250_000`
 - `isVIPMember: Bool = false`
 - `couponCode: String? = nil`
 **Requirements**:
 1. Create `isFreeShipping: Bool` — free shipping applies if `orderSubtotal >= 300_000` OR `isVIPMember == true`.
 2. Use the ternary operator to calculate `shippingFee: Double` (`0` if free, otherwise `30_000`).
 3. Use `??` to compute `appliedCoupon` (if `couponCode` is `nil`, default to `"NO_COUPON"`).
 4. Compute `finalOrderTotal = orderSubtotal + shippingFee` and print the result.
 */
// Write your solution for Exercise 02 here:
