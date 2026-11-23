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
// MARK: - LESSON 17: GENERICS (`<T>`, `some` & `any`)
// ============================================================================
/*:
 ## Lesson 17: Generics (`<T>`, Type Constraints, `some` & `any`)
 - **Generics** let you write flexible, reusable functions and data structures across types without losing compile-time type safety.
 - **Type Constraints** (`<T: Comparable>`): Restrict type parameters `T` to conform to a specific protocol or inherit from a base class.
 - `some Protocol` (**Opaque Type**): Hides the concrete return type while guaranteeing to the compiler that **one fixed underlying type** is returned (e.g., `var body: some View` in SwiftUI!).
 - `any Protocol` (**Existential Type**): Holds heterogeneous values of different concrete types conforming to the same protocol.
 */
printSectionHeader("LESSON 17: GENERICS")

func findMaxValue<T: Comparable>(_ lhs: T, _ rhs: T) -> T {
    lhs > rhs ? lhs : rhs
}
print("Generic Max (Int): \(findMaxValue(15, 42)) | Generic Max (String): \(findMaxValue("Apple", "Swift"))")

// Generic Stack (LIFO)
struct Stack<Element> {
    private var items: [Element] = []

    mutating func push(_ element: Element) {
        items.append(element)
    }

    mutating func pop() -> Element? {
        items.popLast()
    }

    var peek: Element? {
        items.last
    }
}

var bookStack = Stack<String>()
bookStack.push("Clean Architecture")
bookStack.push("Swift Programming")
print("Stack top: \(bookStack.peek ?? "Empty") | Pop: \(bookStack.pop() ?? "Empty")")

// Comparing `some` (Opaque Type) and `any` (Existential Type)
protocol Drawable {
    func draw() -> String
}
struct Circle: Drawable { func draw() -> String { "⚪️ Circle" } }
struct Square: Drawable { func draw() -> String { "⬜️ Square" } }

func makeDefaultShape() -> some Drawable {
    Circle()
}
let canvasShapes: [any Drawable] = [makeDefaultShape(), Square()]
print("Opaque & Existential -> \(canvasShapes.map { $0.draw() }.joined(separator: " | "))")

// MARK: Exercise 17
/*:
 ### 🎯 Exercise 17: Generic `Queue<Element>` & Generic Search Function
 1. Implement `struct Queue<Element>` following **FIFO** (First-In, First-Out) semantics:
    - `mutating func enqueue(_ item: Element)` (append to the back)
    - `mutating func dequeue() -> Element?` (remove and return the front element, or `nil` if empty)
    - `var front: Element?` and `var isEmpty: Bool`
 2. Write a generic function `func findIndex<T: Equatable>(of target: T, in array: [T]) -> Int?` returning the first matching index.
 */
// Write your solution for Exercise 17 here:
