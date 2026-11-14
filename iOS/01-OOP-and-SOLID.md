[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [Next: 2. Swift Core Concepts ›](./02-Swift-Core.md)

---

# 1. Object-Oriented Programming (OOP) & SOLID Principles

## 1.1. Core Programming Concepts
- **What is Programming?** The process of designing and writing source code according to a programming language's syntax to instruct a computer to solve a specific problem.
- **What is a Programming Paradigm?** A fundamental style or approach to structuring and organizing code. Common paradigms include:
  - **Imperative:** Focuses on describing *how* to achieve a result step-by-step (e.g., C).
  - **Declarative:** Focuses on describing *what* the desired outcome is rather than explicit control flow steps (e.g., SwiftUI, SQL).
  - **OOP (Object-Oriented Programming):** Organizes software around objects that bundle state (data) and behavior (methods).
  - **POP (Protocol-Oriented Programming):** A hallmark of Swift that favors `protocol` + `extension` + value types (`struct`, `enum`) to compose behavior cleanly without deep class inheritance hierarchies.
  - **Functional Programming:** Treats functions as first-class citizens, avoids mutable state, and leverages Higher-Order Functions (`map`, `filter`, `reduce`).
- **Class vs. Object:**
  - **Class:** A blueprint defining shared properties and methods for a category of entities.
  - **Object:** A concrete runtime *instance* created from a Class, representing a real-world entity.
- **Model:** A data structure representing a domain entity in an application (e.g., `User`, `Product`), typically implemented as a `struct` or `class`.
- **Function:** A named, self-contained block of code that accepts inputs (parameters), performs a specific task, and optionally returns a value.

## 1.2. Why OOP & The Four Pillars of OOP

**Why use OOP?**
- Models real-world entities and relationships directly in code.
- Encapsulates data and behavior, improving maintainability, extensibility, and reusability.
- Enables objects to interact cleanly through well-defined interfaces.

| Pillar | Definition & Purpose | Practical Usage in Swift / iOS |
| :--- | :--- | :--- |
| **Encapsulation** | Bundles related data and methods inside a single type while hiding internal state from external access. | Enforced via Access Control (`private`, `fileprivate`, `internal`, `public`, `open`). |
| **Inheritance** | Allows building a new class (`subclass`) based on an existing class (`superclass`) to reuse and extend properties and methods. | `class MyVC: UIViewController`. **Note:** Swift classes only support **single inheritance**. |
| **Polymorphism** | Allows different types or methods to share the same interface/name while executing differently at runtime or compile-time. | Method overriding (`override func`), method overloading, or multiple types conforming to the same `protocol`. |
| **Abstraction** | Hides unnecessary implementation complexity and exposes only essential contracts at the design level. | Swift does **not** have an `abstract class` keyword; abstraction is achieved via **`protocol`**. |

> **Common Interview Corrections & Clarifications:**
> - **Does Swift support single or multiple inheritance?** Swift classes support **single inheritance only** (a class can inherit from at most one superclass). In `class A: ClassB, ProtocolC, ProtocolD`, `A` inherits from **one class (`ClassB`)** and conforms to **multiple protocols (`ProtocolC`, `ProtocolD`)**. Writing `class A: ClassB, ClassC` where both are classes is a compile error.
> - **Real-world examples of Polymorphism in Swift:**
>   - *Runtime Polymorphism (Overriding):* `Animal` defines `speak()`. `Dog` overrides it to return `"Woof"`, while `Cat` overrides it to return `"Meow"`.
>   - *Compile-time Polymorphism (Overloading):* Multiple methods with the same name in one type distinguished by parameters:
>     ```swift
>     class Service {
>         func fetch(_ id: String, isCached: Bool) { }
>         func fetch(_ isCached: Bool) -> Bool { return isCached }
>     }
>     ```

## 1.3. Overriding vs. Overloading

- **Overriding:** A subclass provides a custom implementation of an *instance method*, *type method*, *property*, or *subscript* inherited from its superclass using the `override` keyword.
- **Overloading:** Defining multiple functions with the **same name** within the same scope that differ in their signature:
  1. Different **number of parameters** (`func add(a: Int)` vs. `func add(a: Int, b: Int)`).
  2. Different **parameter types** (`func log(_ x: Int)` vs. `func log(_ x: String)`).
  3. Different **argument labels** (e.g., `stride(from:to:by:)` vs. `stride(from:through:by:)`).
  4. Different **return types** (`func getValue() -> Int` vs. `func getValue() -> String`).

## 1.4. The Five SOLID Principles (OOD)

Introduced by Robert C. Martin, SOLID is a set of five object-oriented class design principles that promote loose coupling, high cohesion, testability, and long-term maintainability.

| Letter | Principle | Summary | iOS Example |
| :---: | :--- | :--- | :--- |
| **S** | **Single Responsibility Principle (SRP)** | A class should have **one, and only one, reason to change** (one clear responsibility). | Extract `NetworkManager` and `CacheManager` out of `ViewController` instead of cramming networking and persistence into the VC. |
| **O** | **Open/Closed Principle (OCP)** | Software entities should be **open for extension, but closed for modification**. | Define `protocol PaymentMethod` so new methods (`ApplePay`, `Stripe`) can be added without modifying `CheckoutService`. |
| **L** | **Liskov Substitution Principle (LSP)** | Subtypes must be **substitutable for their base types** without altering the correctness of the program. | A subclass overriding a superclass method must honor its behavioral contract (e.g., not breaking expected postconditions or throwing unexpected fatal errors). |
| **I** | **Interface Segregation Principle (ISP)** | Clients should **not be forced to depend on interfaces they do not use**. | Split a bloated `WorkerProtocol` (`code()`, `design()`, `test()`) into focused protocols like `CodableWorker` and `DesignableWorker`. |
| **D** | **Dependency Inversion Principle (DIP)** | High-level modules should not depend on low-level modules; **both should depend on abstractions** (`protocol`). | `UserViewModel` depends on `UserRepositoryProtocol` instead of concrete `AlamofireUserRepository`, making unit testing with mocks easy. |

---

[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [Next: 2. Swift Core Concepts ›](./02-Swift-Core.md)
