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
// MARK: - LESSON 19: ACCESS CONTROL
// ============================================================================
/*:
 ## Lesson 19: Access Control
 Five access levels from least restrictive to most restrictive:
 1. `open`: Accessible and subclassable/overridable from other modules (`class` only).
 2. `public`: Accessible from other modules, but cannot be subclassed/overridden outside the defining module.
 3. `internal`: **Default** — accessible within the entire current app/module.
 4. `fileprivate`: Accessible only within the same `.swift` source file.
 5. `private`: Accessible only within the enclosing declaration (and its extensions in the same file).

 > 💡 **Best Practice**: Use **`private(set) var`** so external code can **read** a property freely while only internal methods can **modify** it!
 */
printSectionHeader("LESSON 19: ACCESS CONTROL")

extension Int {
    var formattedVND: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let numberText = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(numberText) VND"
    }
}

struct SecureWallet {
    let ownerName: String
    private(set) var balance: Int = 0         // Read-only externally; prevents `wallet.balance = ...`
    private var auditLogs: [String] = []      // Completely hidden from external callers

    init(ownerName: String, initialBalance: Int) {
        self.ownerName = ownerName
        self.balance = max(0, initialBalance)
    }

    mutating func deposit(_ amount: Int) {
        guard amount > 0 else { return }
        balance += amount
        auditLogs.append("+\(amount)")
    }

    func summary() -> String {
        "Wallet(\(ownerName)) | Balance: \(balance.formattedVND) | Transactions: \(auditLogs.count)"
    }
}

var myWallet = SecureWallet(ownerName: "Lam", initialBalance: 100_000)
myWallet.deposit(250_000)
// myWallet.balance = 9_999_999 // Compile error: protects data integrity!
print(myWallet.summary())

// MARK: Exercise 19
/*:
 ### 🎯 Exercise 19: Encapsulated Inventory (`InventoryProduct`)
 Design `struct InventoryProduct`:
 1. `let sku: String`, `let name: String`.
 2. `private(set) var quantityInStock: Int` (initialized as non-negative).
 3. `private var changeHistory: [String]` tracking stock-in / stock-out entries.
 4. Implement `mutating func restock(_ count: Int)` and `mutating func fulfillOrder(_ count: Int) -> Bool` (returning `false` if stock is insufficient).
 */
// Write your solution for Exercise 19 here:
