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
// MARK: - LESSON 18: ARC MEMORY MANAGEMENT & PREVENTING RETAIN CYCLES
// ============================================================================
/*:
 ## Lesson 18: Memory Management (ARC) & Preventing Retain Cycles
 - Swift automatically manages memory for `class` instances via **ARC (Automatic Reference Counting)**, deallocating an instance as soon as its `strong` reference count drops to `0`.
 - **Retain Cycle (Memory Leak)**: Occurs when two class instances hold `strong` references to each other, or when an `@escaping` closure stored by an object strongly captures `self`.
 - **Standard Solutions**:
   - Mark one side of the relationship as `weak var` (always Optional, automatically set to `nil` when deallocated) or `unowned`.
   - Always use a capture list **`[weak self]`** in escaping closures stored on `self`.
 */
printSectionHeader("LESSON 18: ARC & PREVENTING RETAIN CYCLES")

class Tenant {
    let name: String
    var apartment: Apartment? // Strong reference
    init(name: String) { self.name = name }
    deinit { print("  🗑️ [ARC deinit] Tenant '\(name)' deallocated!") }
}

class Apartment {
    let unitNumber: String
    weak var currentTenant: Tenant? // `weak` breaks the strong reference cycle!
    init(unitNumber: String) { self.unitNumber = unitNumber }
    deinit { print("  🗑️ [ARC deinit] Apartment '\(unitNumber)' deallocated!") }
}

// Demonstrating `[weak self]` inside a closure owned by a class
class ProfileViewModel {
    let screenName: String
    var onReloadCompleted: (() -> Void)?

    init(screenName: String) { self.screenName = screenName }

    func bindAction() {
        onReloadCompleted = { [weak self] in
            guard let self else { return }
            print("  [weak self] Refreshed screen: \(self.screenName)")
        }
    }

    deinit { print("  🗑️ [ARC deinit] ProfileViewModel '\(screenName)' deallocated!") }
}

do {
    let tenant = Tenant(name: "Hoang")
    let unit = Apartment(unitNumber: "A-802")
    tenant.apartment = unit
    unit.currentTenant = tenant

    let viewModel = ProfileViewModel(screenName: "UserProfile")
    viewModel.bindAction()
    viewModel.onReloadCompleted?()
} // Upon exiting `do`, all 3 instances call `deinit` cleanly thanks to `weak` and `[weak self]`!

// MARK: Exercise 18
/*:
 ### 🎯 Exercise 18: Detect & Fix a Retain Cycle (Memory Leak)
 Suppose you have `class Author` (`var publishedBook: BookRecord?`) and `class BookRecord` (`var author: Author?`).
 1. Implement both classes with `deinit` printing a deallocation message.
 2. Mark the appropriate property `weak` so that assigning `author.publishedBook = book` and `book.author = author` inside a `do { ... }` block allows both objects to deallocate immediately when the block exits.
 */
// Write your solution for Exercise 18 here:
