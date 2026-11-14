[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 1. Object-Oriented Programming (OOP) & SOLID Principles](./01-OOP-and-SOLID.md) | [Next: 3. Memory Management (ARC & Retain Cycles) ›](./03-ARC-and-Memory-Management.md)

---

# 2. Swift Core Concepts

## 2.1. Swift Overview & Optionals
- **What is Swift?** A modern programming language introduced by Apple in 2014 for iOS, macOS, watchOS, tvOS, and Linux. Designed to work seamlessly with Cocoa, Cocoa Touch, and Objective-C, Swift is **statically typed** (type-checked at compile time) and **compiled** to native machine code.
- **What is an Optional?** Represents a variable that may hold a value or the absence of a value (`nil`). Under the hood, `Optional` is a generic `enum`:
  ```swift
  enum Optional<Wrapped> {
      case none
      case some(Wrapped)
  }
  ```
- **5 Ways to Unwrap Optionals:**
  1. **Force Unwrapping (`!`):** Extracts the value directly. Use **only** when guaranteed non-nil; otherwise, it triggers a runtime crash (`Fatal error: Unexpectedly found nil`).
  2. **Implicitly Unwrapped Optional (`var name: String!`):** Treated as optional under the hood but automatically unwrapped on access; commonly used for `@IBOutlet` or properties guaranteed to be initialized shortly after `init`.
  3. **Optional Binding (`if let` / `if var`, `guard let`):** Safely checks whether an optional contains a value and binds it to a temporary constant/variable.
  4. **Optional Chaining (`?.`):** Queries properties, methods, and subscripts on an optional (e.g., `person?.info?.address`). If any link in the chain is `nil`, the entire expression evaluates gracefully to `nil`.
  5. **Nil-Coalescing Operator (`??`):** Unwraps the optional if it has a value, or returns a fallback default value (e.g., `let name = user.name ?? "Guest"`).

- **`if let` vs. `guard let`:**

| Aspect | `if let` | `guard let` |
| :--- | :--- | :--- |
| **Control Flow Priority** | Handles the **non-nil (happy) path** first. | Handles the **`nil` (failure / early exit) path** first. |
| **Scope Exit Requirement** | Does **not** require `return`, `throw`, or `break`. | The `else` block **must exit the current scope** (`return`, `throw`, `break`, `continue`, `fatalError`). |
| **Unwrapped Variable Scope** | Accessible **only inside** the `if let { ... }` block. | Accessible **in the outer scope** for the remainder of the function/block after `guard let`. |
| **Best Use Case** | Branching locally when both nil and non-nil paths continue execution. | Sequential validation / preconditions to keep code flat and avoid nested "pyramid of doom". |

## 2.2. Struct vs. Class (Value Type vs. Reference Type)

- **Similarities:**
  - Both can define stored and computed properties and methods.
  - Both support subscripts, initializers (`init`), extensions, and protocol conformance.
- **Comparison Table:**

| Feature | `Struct` (Value Type) | `Class` (Reference Type) |
| :--- | :--- | :--- |
| **Assignment / Passing Behavior** | **Assign-by-copy:** Creates an independent copy when assigned or passed to a function. Modifying one does not affect the other. | **Assign-by-reference:** Copies the pointer to the same instance in memory. Modifying through one reference mutates the shared instance. |
| **Memory Allocation** | Typically allocated on the **Stack** (fast allocation/deallocation tied to scope). *Note:* If a struct is a property inside a class, it resides on the **Heap** with that class instance. | Instances are always allocated on the **Heap** (slower allocation/deallocation overhead). |
| **Memory Management** | Automatically freed when exiting scope; **does not use ARC** and has **no `deinit`**. | Managed by **ARC (Automatic Reference Counting)**; supports **`deinit`**. |
| **Inheritance** | **No** class inheritance (can conform to protocols). | Supports **single inheritance** from a superclass and multiple protocol conformances. |
| **Default Initializer** | Automatically synthesizes a **Memberwise Initializer** (define custom `init` inside an `extension` to preserve the default memberwise `init`). | Does **not** synthesize a memberwise `init`; all non-optional stored properties must have defaults or be set in a custom `init`. |
| **Method Dispatch** | **Static Dispatch** (resolved at compile time -> faster). | **Dynamic Dispatch** (vtable / Obj-C message dispatch -> supports overriding, slightly slower). |
| **Declared with `let`** | **Completely immutable** (internal properties cannot be mutated). | Reference is constant (cannot point to a new instance), but **`var` properties inside remain mutable**. |
| **Mutating Methods** | Methods that modify `self` or its properties must be marked **`mutating`**. | No `mutating` keyword needed. |
| **Equality vs. Identity** | Compared by value using **`==`** (via `Equatable`). | Supports identity operators **`===`** and **`!==`** to check whether two variables point to the exact same instance. |
| **Thread Safety** | Safer across threads because each context works on its own copy. | Prone to race conditions if multiple threads mutate the same shared instance. |

- **Interview Scenario Question:**
  > *"If you have a `struct` (or `class`) with a variable inside, and you pass it to a function to modify that variable, does it mutate the original object or create a new copy?"*
  - **For a `Struct`:** Passing a `struct` to a normal function passes an immutable copy (`let`), so it cannot modify the original directly. You either return a new modified `struct`, mark the parameter as **`inout`** (passing with `&` at the call site, which uses copy-in copy-out semantics), or use a **`mutating func`** directly on the `struct`.
  - **For a `Class`:** Passing a `class` instance copies the reference pointing to the **same object on the Heap**, so mutating its properties inside the function **directly modifies the original object**.

## 2.3. Deep Dive into Initialization

- **Struct Initialization:**
  1. Default initializer (when all properties have default values) & Memberwise `init(...)`.
  2. Placing custom `init` inside an `extension`: Preserves Swift's synthesized Memberwise `init`.
  3. **Initializer Delegation:** An `init` calls `self.init(...)`. You cannot access `self` before calling `self.init(...)`.
- **Class Initialization:**
  - **Designated Initializer (`init`):** Primary initializer responsible for initializing all non-optional stored properties introduced by that class and calling `super.init(...)` up the inheritance chain.
  - **Convenience Initializer (`convenience init`):** Secondary helper initializer that must call `self.init(...)` on another initializer in the same class (ultimately delegating to a designated initializer). Cannot assign `self.property` before calling `self.init(...)`.
- **3 Initialization Funnel Rules (Class Hierarchy):**
  1. A `designated init` must call a `designated init` from its immediate **superclass** (`super.init(...)`).
  2. A `convenience init` must call another `init` from the **same class** (`self.init(...)`).
  3. A `convenience init` must **ultimately call a `designated init`** (never `super.init` directly).
- **Two-Phase Initialization:**
  - **Phase 1 (Bottom-Up):** All stored properties are initialized from the subclass up to the root superclass (`super.init`). *You cannot use `self`, call instance methods, or read uninitialized properties during Phase 1.*
  - **Phase 2 (Top-Down):** Once the base class finishes Phase 1, memory is fully initialized. Control flows back down, and you may now use `self`, call instance methods, and customize inherited properties.
- **Initializer Inheritance & Overriding:**
  - Subclasses do not inherit superclass initializers by default unless (a) the subclass defines no designated initializers of its own, or (b) it overrides all superclass designated initializers.
  - Matching a superclass designated initializer signature requires the `override` keyword.
- **Handling Initialization Failure:**
  - **Failable Initializer (`init?` or `init!`):** Returns `nil` when initialization fails.
  - **Throwing Initializer (`init(...) throws`):** Throws a descriptive `Error` explaining why initialization failed.

## 2.4. Properties, Subscripts, KeyPaths & Property Wrappers

- **Types of Properties in Swift:**
  1. **Stored Properties:** Allocate memory to store a constant (`let`) or variable (`var`) value.
  2. **Lazy Stored Properties (`lazy var`):** Initial value is calculated **only once** when first accessed. Useful for expensive setup or properties depending on `self` after `init`. *(Note: Always `var`, and not inherently thread-safe).*
  3. **Computed Properties:** Do not store a value; instead, compute it on each access via a getter (`get`) and an optional setter (`set`).
  4. **Property Observers (`willSet`, `didSet`):** Respond to changes before (`newValue`) and after (`oldValue`) a stored property is set *(not called during `init`)*.
  5. **Type Properties (`static` vs. `class`):** Belong to the type itself rather than an instance.
     - `static`: Works on `struct`, `enum`, and `class`. **Cannot be overridden** by subclasses.
     - `class`: Only in `class` (for computed type properties and type methods). **Allows subclasses to `override`**.
- **Property Wrappers (`@propertyWrapper`):**
  > **Clarification / Correction from original notes:** Property Wrappers are **not** Optional unwrapping tools (`if let`/`guard let`).
  - Introduced in Swift 5.1, a **Property Wrapper** is a reusable wrapper type (`@propertyWrapper struct/class`) that encapsulates read/write/validation/storage logic around a property via `wrappedValue`.
  - **Common examples:** `@State`, `@Binding`, `@ObservedObject`, `@StateObject`, `@EnvironmentObject`, `@Environment` (SwiftUI), `@Published` (Combine), `@AppStorage`, or a custom `@UserDefault` wrapper.
- **Subscripts:** Overload the `[]` operator on classes, structs, or enums to provide shortcut access to collection/sequence elements (e.g., `matrix[row, col]`).
- **KeyPaths:** Store a **reference to a property path** rather than the property's value itself (e.g., `let namePath = \User.name`, accessed via `user[keyPath: namePath]` or `users.map(\.name)`).
- **`dynamic` Keyword:** Tells the compiler to use **Objective-C dynamic dispatch** instead of Swift static/vtable dispatch; commonly paired with `@objc` for **KVO** and **Method Swizzling**.

## 2.5. Functions, Closures & Higher-Order Functions

- **Function vs. Closure:**

| Aspect | Function | Closure |
| :--- | :--- | :--- |
| **Definition** | A **named** block of code declared with `func`. | A self-contained, **anonymous** block of code `{ (params) -> ReturnType in ... }`. |
| **Usage** | Invoked by name. Parameters are `let` constants by default; modifying a passed variable requires **`inout`** and **`&`**. | Assigned to variables/properties or passed around as arguments (completion handlers, callbacks). |
| **Value Capturing** | Global functions do not capture external state; nested functions can capture enclosing values. | Implicitly captures and stores references to variables from its surrounding context. |
| **Type Semantics** | One of the three closure forms in Swift. | **Reference Type:** Assigning a closure to another variable shares the same closure and capture list. |

- **Three Forms of Closures in Swift:**
  1. **Global functions:** Named closures that do not capture any values.
  2. **Nested functions:** Named closures that can capture values from their enclosing function.
  3. **Closure expressions:** Unnamed inline closures with lightweight syntax (`$0`, `$1`, trailing closure syntax) that can capture surrounding values.
- **Non-escaping vs. `@escaping` Closures:**
  - **Non-escaping (default):** Executed synchronously before the receiving function returns and then released. Does not require explicit `self.`.
  - **`@escaping`:** Can **outlive the function scope**—for example, stored in a property or invoked asynchronously after a network call or `DispatchQueue.async` finishes. Requires explicit `self.` (or `[weak self]`) inside the closure to avoid accidental retain cycles.
- **Higher-Order Functions:** Functions that take other functions/closures as arguments or return a function/closure:
  - `sorted(by:)`: Returns a new sorted array according to the closure comparator (whereas `sort(by:)` mutates in place).
  - `filter(_:)`: Returns an array containing only elements that satisfy a boolean predicate.
  - `map(_:)`: Transforms every element in a collection while preserving element count.
  - `compactMap(_:)`: Transforms each element and **discards `nil` results** (replaced `flatMap` for optional-unwrapping use cases since Swift 4.1).
  - `flatMap(_:)`: Transforms elements and **flattens** nested collections into a single-level array.
  - `reduce(_:_:)`: Combines all elements into a single accumulated value starting from `initialResult` (e.g., `nums.reduce(0, +)`).

- **Quick Comparison (`map` vs. `flatMap` vs. `compactMap`):**
  - `[1, 2, 3].map { $0 * 2 }` -> `[2, 4, 6]`
  - `[[1, 2], [3, 4]].flatMap { $0 }` -> `[1, 2, 3, 4]` *(flattens 2D array to 1D)*
  - `[1, nil, 2, nil, 3].compactMap { $0 }` -> `[1, 2, 3]` *(removes `nil` values)*

## 2.6. Protocols, Tuples & Generics

- **Protocol:**
  - Defines a blueprint of methods, properties, and requirements that a `class`, `struct`, or `enum` adopts (*conforms to*).
  - **Property Requirements:** Always declared with `var` (never `let` or default values) plus `{ get }` or `{ get set }`. Supports `static` for type-level requirements.
  - **Mutating Methods:** Methods expected to mutate value types (`struct`/`enum`) must be marked `mutating` in the protocol (`class` conformers omit `mutating`).
  - **Protocol Extensions & Optional Requirements:** Provide **default implementations** or add new helper methods to all conforming types. This enables pure-Swift **optional protocol methods** without requiring `@objc optional`.
  - **`associatedtype`:** Declares a placeholder type in a protocol whose concrete type is specified by each conforming type.
  - **Applications:** Delegation pattern, Protocol-Oriented Programming, Swift Standard Library (`Equatable`, `Comparable`, `Hashable`, `Codable`), and existential/opaque types (`any Protocol`, `some Protocol`).
- **Tuple:** Groups multiple values (possibly of different types) into a single compound value using parentheses `()`, often used to return multiple values from a function. Can be named `(code: 200, message: "OK")` or unnamed `(200, "OK")`. Tuples cannot conform to protocols or declare methods.
- **Generics:** Allow writing flexible, reusable functions and types (`class`, `struct`, `enum`) parameterized over types (e.g., `func swapValues<T>(_ a: inout T, _ b: inout T)`), optionally restricted with **Type Constraints** like `class Keeper<Animal: Pet>`.

## 2.7. Access Control Levels (Most Permissive to Most Restrictive)

1. **`open`** *(classes & class members only)*: Accessible across all source files in the defining module and any importing module; **allows subclassing and overriding from outside the module** (e.g., `UICollectionView` in `UIKit`).
2. **`public`**: Accessible across modules, but **cannot be subclassed or overridden outside the defining module**.
3. **`internal`** *(default if unspecified)*: Accessible from any source file **within the same module/target**.
4. **`fileprivate`**: Accessible **only within the defining `.swift` source file**.
5. **`private`**: Accessible **only within the enclosing declaration** and extensions of that type **in the same file**.

*(Swift 6 also introduces `package` access level between `public` and `internal` for targets within the same Swift package).*

---

[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 1. Object-Oriented Programming (OOP) & SOLID Principles](./01-OOP-and-SOLID.md) | [Next: 3. Memory Management (ARC & Retain Cycles) ›](./03-ARC-and-Memory-Management.md)
