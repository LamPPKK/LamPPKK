[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 2. Swift Core Concepts](./02-Swift-Core.md) | [Next: 4. iOS SDK & UIKit (Fundamentals & Advanced) ›](./04-iOS-SDK-and-UIKit.md)

---

# 3. Memory Management (ARC & Retain Cycles)

## 3.1. What is ARC? ARC vs. Non-ARC (MRC)
- **ARC (Automatic Reference Counting):** Swift and Objective-C's memory management mechanism for **Reference Types (`class`, `closure`)**. The compiler automatically inserts retain/release operations at compile time to track how many `strong` references point to each instance. When an object's reference count drops to `0`, ARC runs `deinit` and deallocates its memory on the Heap.
- **Non-ARC / MRC (Manual Reference Counting):** Legacy Objective-C approach where developers manually invoked `retain`, `release`, and `autorelease`, making memory leaks and dangling-pointer crashes far more common.
- **When does ARC increase or decrease the reference count?**
  - **Increases (+1):** When an object is created via `init` and assigned to a strong variable/constant/property, or when an additional strong reference is assigned (another variable, property, or added to a collection).
  - **Decreases (-1):** When a strong variable/property is set to `nil`, goes out of scope, its owning object is deallocated, or the object is removed from a collection.

## 3.2. Strong, Weak & Unowned References

| Characteristic | `strong` (Default) | `weak` | `unowned` |
| :--- | :--- | :--- | :--- |
| **Reference Count Impact** | **Increments (+1)** reference count. | Does **not** increment reference count. | Does **not** increment reference count. |
| **Type Requirement** | Optional or Non-optional. | **Must be an Optional `var`**, because ARC sets it to `nil` on deallocation. | **Typically Non-optional** (optional `unowned` also supported since Swift 5); **never set to `nil` by ARC**. |
| **When Target Deallocates** | Prevents target from being deallocated while held. | Safely becomes **`nil`** -> no crash when inspected. | Accessing it after deallocation causes an immediate **Runtime Crash** (dangling reference). |
| **When to Use** | Standard ownership of objects. | When the referenced object has a **shorter lifetime or may become `nil`** (e.g., `delegate`, subviews, `[weak self]` in closures). | Only when **100% certain** the referenced object will **outlive** (or share the exact lifetime of) the referencing object (e.g., child pointing back to parent). |

## 3.3. Retain Cycles (Strong Reference Cycles) & Prevention

- **What is a Retain Cycle?** Occurs when two or more class instances (or an instance and a closure) hold `strong` references to each other. Both retain counts remain $\ge 1$, preventing ARC from ever deallocating them and causing a **Memory Leak**.
- **Two Most Common Causes:**
  1. **Mutual strong references between classes:** e.g., `ParentVC` strongly holds `ChildVC`, and `ChildVC.delegate` strongly points back to `ParentVC`. -> *Fix:* Declare `weak var delegate: SomeDelegate?`.
  2. **Closures strongly capturing `self`:** An object stores an `@escaping` closure (or an active network/timer callback) that calls `self.doWork()` without a capture list. -> *Fix:* Capture `[weak self]`.
- **Understanding `[weak self]` and `guard let self = self`:**
  - `[weak self]`: Capture list instructing the closure to hold a weak reference to `self` (`self` becomes `Self?` inside the closure), allowing the object to be deallocated if dismissed before the closure completes.
  - `guard let self = self else { return }`: Safely unwraps weak `self` into a temporary local strong reference for the closure's execution scope. This avoids writing `self?.` repeatedly, ensures `self` stays alive through the block, and lets you pass non-optional values cleanly (e.g., `Bool` properties).

---

[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 2. Swift Core Concepts](./02-Swift-Core.md) | [Next: 4. iOS SDK & UIKit (Fundamentals & Advanced) ›](./04-iOS-SDK-and-UIKit.md)
