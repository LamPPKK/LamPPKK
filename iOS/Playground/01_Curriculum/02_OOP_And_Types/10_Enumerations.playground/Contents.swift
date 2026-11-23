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
// MARK: - LESSON 10: ENUMERATIONS
// ============================================================================
/*:
 ## Lesson 10: Enumerations (`enum`)
 `enum` in Swift is a first-class, versatile type:
 - Conform to `CaseIterable` to iterate over all cases via `.allCases`.
 - **Raw Values**: Attach fixed underlying values (`String`, `Int`, etc.) and initialize via `init?(rawValue:)`.
 - **Associated Values**: Attach custom, per-case data payloads of any type!
 - Can define **Computed Properties** and **Methods** directly inside the `enum`.
 */
printSectionHeader("LESSON 10: ENUMERATIONS")

// 10.1 Enum with Raw Values & CaseIterable
enum CompassDirection: String, CaseIterable {
    case north = "North"
    case south = "South"
    case east = "East"
    case west = "West"
}
let allDirections = CompassDirection.allCases.map(\.rawValue).joined(separator: ", ")
print("All compass directions: \(allDirections)")

// 10.2 Enum with Associated Values + Computed Property
enum PaymentMethod {
    case cash
    case bankTransfer(bankName: String, accountNumber: String)
    case eWallet(provider: String, discountAmount: Int?)

    var summaryDescription: String {
        switch self {
        case .cash:
            return "Cash on Delivery (COD)"
        case let .bankTransfer(bankName, accountNumber):
            return "Bank transfer via \(bankName) - Account: \(accountNumber)"
        case let .eWallet(provider, discountAmount):
            if let discountAmount {
                return "\(provider) Wallet (Discount: \(discountAmount) VND)"
            }
            return "\(provider) Wallet"
        }
    }
}

let selectedPayment = PaymentMethod.eWallet(provider: "MoMo", discountAmount: 25_000)
print("Associated Value -> \(selectedPayment.summaryDescription)")

// Match a single case concisely using `if case let`
if case let .eWallet(provider, _) = selectedPayment {
    print("if case let -> Paying via wallet: \(provider)")
}

// MARK: Exercise 10
/*:
 ### 🎯 Exercise 10: Delivery Status Tracking
 1. Define `enum DeliveryStatus` with cases:
    - `.pending`
    - `.inTransit(carrier: String, remainingStops: Int)`
    - `.delivered(recipientName: String)`
    - `.failed(reason: String)`
 2. Implement `func statusMessage() -> String` inside `DeliveryStatus` returning a descriptive message for each case.
 3. Create an array of 3 deliveries in different states and print each `statusMessage()`.
 */
// Write your solution for Exercise 10 here:
