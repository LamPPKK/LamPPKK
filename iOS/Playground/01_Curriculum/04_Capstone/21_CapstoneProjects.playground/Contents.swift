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
// MARK: - LESSON 21: CAPSTONE PROJECTS
// ============================================================================
/*:
 ## Lesson 21: End-of-Course Capstone Projects
 Below is a working mini-demo followed by **3 tiered capstone challenges** to consolidate all core Swift skills before moving on to **SwiftUI / UIKit**.
 */
printSectionHeader("LESSON 21: CAPSTONE MINI-PROJECT DEMO & CHALLENGES")

// --- Working Demo: Student Cohort Grade Report ---
enum Track: String {
    case iOS = "iOS Engineering"
    case backend = "Server-Side Swift"
    case crossPlatform = "Multiplatform"
}

struct Student {
    let studentID: String
    let fullName: String
    let track: Track
    var scores: [Double]

    var averageScore: Double? {
        guard !scores.isEmpty else { return nil }
        return scores.reduce(0, +) / Double(scores.count)
    }

    var isGraduated: Bool {
        (averageScore ?? 0) >= 7.0
    }
}

let cohort: [Student] = [
    Student(studentID: "SV01", fullName: "Tran Minh", track: .iOS, scores: [8.5, 9.0, 8.8]),
    Student(studentID: "SV02", fullName: "Le Thao", track: .iOS, scores: [6.0, 6.5, 6.8]),
    Student(studentID: "SV03", fullName: "Pham Quoc", track: .backend, scores: [9.2, 9.5, 9.0]),
    Student(studentID: "SV04", fullName: "Vu Ha", track: .crossPlatform, scores: [])
]

let graduatedStudents = cohort
    .filter(\.isGraduated)
    .sorted { ($0.averageScore ?? 0) > ($1.averageScore ?? 0) }

print("🎓 Graduated students (GPA >= 7.0):")
for student in graduatedStudents {
    let formattedAvg = String(format: "%.2f", student.averageScore ?? 0)
    print("  - [\(student.studentID)] \(student.fullName) (\(student.track.rawValue)) -> GPA: \(formattedAvg)")
}

let groupedByTrack = Dictionary(grouping: cohort, by: \.track)
print("Number of students in iOS track: \(groupedByTrack[.iOS]?.count ?? 0)")

// MARK: Capstone 01 (Beginner - Intermediate)
/*:
 ---
 ### 🏆 CAPSTONE 01: E-Commerce Shopping Cart (`ShoppingCart`)
 **Concepts**: `struct`, `enum` (Associated Values), `Optional`, `Higher-Order Functions`, `private(set)`.

 **Requirements**:
 1. Create `struct Product: Equatable` with `id: String`, `name: String`, `price: Int`, `category: String`.
 2. Create `struct CartItem` with `product: Product` and `quantity: Int` (plus computed property `subtotal: Int`).
 3. Create `enum Voucher` with cases:
    - `.fixedAmount(Int)` (e.g., `50_000` off)
    - `.percentage(Int, maxDiscount: Int)` (percentage off capped at `maxDiscount`)
    - `.freeShipping`
 4. Create `struct ShoppingCart` with `private(set) var items: [CartItem] = []`:
    - `mutating func addProduct(_ product: Product, quantity: Int)`: increment `quantity` if already in cart, otherwise add a new item.
    - `mutating func removeProduct(byID productID: String)`: remove the matching item from the cart.
    - `func checkoutTotal(shippingFee: Int, voucher: Voucher?) -> Int`: calculate the final payable total (never negative).
 */
// Write your Capstone 01 solution here:


// MARK: Capstone 02 (Intermediate - OOP/POP & Error Handling)
/*:
 ---
 ### 🏆 CAPSTONE 02: Library Borrowing System (`LibrarySystem`)
 **Concepts**: `protocol`, `class`, `ARC (weak)`, `Error Handling (throws)`, `Access Control`.

 **Requirements**:
 1. Create `enum LibraryError: Error` with cases:
    - `.itemNotFound(id: String)`
    - `.alreadyBorrowed(byMember: String)`
    - `.borrowLimitExceeded(limit: Int)`
 2. Create `protocol Borrowable: AnyObject` with `var itemID: String { get }`, `var title: String { get }`, `var isAvailable: Bool { get }`.
 3. Create `class BookItem: Borrowable` and `class Member` (each `Member` may borrow at most `3` books simultaneously; use `weak` appropriately for two-way references to prevent retain cycles!).
 4. Create `class LibraryManager`:
    - Manage registered books and members.
    - Implement `func borrowItem(itemID: String, memberID: String) throws` and `func returnItem(itemID: String, memberID: String) throws`.
    - Test successful borrowing, borrowing an unavailable book, and exceeding the 3-book limit inside `do-try-catch` blocks.
 */
// Write your Capstone 02 solution here:


// MARK: Capstone 03 (Advanced - Codable, Generics & Concurrency)
/*:
 ---
 ### 🏆 CAPSTONE 03: Personal Expense Tracker & Cloud Sync (`ExpenseTracker`)
 **Concepts**: `Codable` (JSON), `Generics`, `Higher-Order Functions`, `async/await`, `actor`.

 **Requirements**:
 1. Create `enum TransactionType: String, Codable` with `.income` and `.expense`.
 2. Create `struct Transaction: Codable, Identifiable` with `id: UUID`, `title: String`, `amount: Int`, `category: String`, `type: TransactionType`.
 3. Create a generic `actor InMemoryRepository<Item: Identifiable>` supporting:
    - `func add(_ item: Item)`
    - `func getAll() -> [Item]`
    - `func filter(_ predicate: @Sendable (Item) -> Bool) -> [Item]`
 4. Write `func exportTransactionsToJSON(_ transactions: [Transaction]) throws -> String` to export transactions as pretty-printed JSON (`prettyPrinted`).
 5. Inside a `Task`, add at least 5 income/expense transactions, calculate total income, total expenses, net balance, and identify the highest-spending category!
 */
// Write your Capstone 03 solution here:
