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
// MARK: - LESSON 11: STRUCT VS CLASS — VALUE TYPE VS REFERENCE TYPE
// ============================================================================
/*:
 ## Lesson 11: `struct` vs `class` (Value Type vs Reference Type)
 This is the most important foundational distinction when working with Swift, SwiftUI, and UIKit!

 | Criteria | `struct` (Value Type) | `class` (Reference Type) |
 |---|---|---|
 | Assigning `b = a` | **Creates an independent copy** (editing `b` does not affect `a`) | **Shares the same instance** (editing `b` changes `a`) |
 | Initializers | Automatic **Memberwise `init`** | Must write `init` if properties lack defaults |
 | Inheritance | Not supported between structs | Supports single class inheritance |
 | Mutating properties | Methods must be marked `mutating` | No `mutating` keyword needed |
 | Memory | Lightweight, thread-safe, no retain cycles | Heap-allocated, managed by **ARC** |

 > 💡 **Apple's Recommendation**: Prefer **`struct`** by default. Use `class` only when you need shared mutable state, class inheritance, or interoperability with Objective-C / UIKit APIs.
 */
printSectionHeader("LESSON 11: STRUCT VS CLASS — VALUE VS REFERENCE")

// 11.1 Struct is a Value Type (Independent Copy)
struct HomeStruct {
    var roomCount: Int = 2

    mutating func addRooms(_ count: Int) {
        roomCount += count
    }
}

let originalHomeStruct = HomeStruct()
var copiedHomeStruct = originalHomeStruct
copiedHomeStruct.addRooms(3) // Modifies only the copy!

print("STRUCT (Value Type) -> original: \(originalHomeStruct.roomCount) rooms | copy: \(copiedHomeStruct.roomCount) rooms")

// 11.2 Class is a Reference Type (Shared Instance)
class HomeClass {
    var roomCount: Int
    init(roomCount: Int = 2) {
        self.roomCount = roomCount
    }
}

let originalHomeClass = HomeClass()
let referencedHomeClass = originalHomeClass // Even with `let`, properties inside a class instance can change!
referencedHomeClass.roomCount = 10          // Both variables point to the exact same object on the heap!

print("CLASS (Reference Type) -> original: \(originalHomeClass.roomCount) rooms | reference: \(referencedHomeClass.roomCount) rooms")
print("Identical memory address (===)? \(originalHomeClass === referencedHomeClass)")

// MARK: Exercise 11
/*:
 ### 🎯 Exercise 11: Practical Comparison — `Point2D` (Struct) vs `GameCharacter` (Class)
 1. Create `struct Point2D` with `var x: Double`, `var y: Double`, and `mutating func moveBy(dx: Double, dy: Double)`.
    Initialize `pointA = Point2D(x: 0, y: 0)`, copy to `var pointB = pointA`, move `pointB`, and verify `pointA`'s coordinates remain unchanged.
 2. Create `class GameCharacter` with `var name: String`, `var health: Int`, and `func takeDamage(_ amount: Int)` (never allowing negative `health`).
    Create `hero = GameCharacter(name: "Arthur", health: 100)`, assign `let partyLeader = hero`, call `partyLeader.takeDamage(30)`, and check `hero.health` along with `===`.
 */
// Write your solution for Exercise 11 here:
