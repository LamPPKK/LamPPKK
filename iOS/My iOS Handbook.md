![My iOS Handbook Banner](./images/handbook-banner.jpg)

# My iOS Handbook

> A comprehensive, standardized iOS interview preparation handbook covering Swift, UIKit, Memory Management, Persistence, Concurrency, Software Architecture, Reactive Programming, Debugging, Unit Testing, and Live Coding / Algorithm Exercises — curated and corrected from real iOS technical interview notes and assessments.

![Divider](./images/divider.png)

## Table of Contents

### Part I: iOS & Swift Interview Theory

- **[1. Object-Oriented Programming (OOP) & SOLID Principles](./01-OOP-and-SOLID.md)**
  - 1.1. Core Programming Concepts
  - 1.2. Why OOP & The Four Pillars of OOP
  - 1.3. Overriding vs. Overloading
  - 1.4. The Five SOLID Principles (OOD)
- **[2. Swift Core Concepts](./02-Swift-Core.md)**
  - 2.1. Swift Overview & Optionals
  - 2.2. Struct vs. Class (Value Type vs. Reference Type)
  - 2.3. Deep Dive into Initialization
  - 2.4. Properties, Subscripts, KeyPaths & Property Wrappers
  - 2.5. Functions, Closures & Higher-Order Functions
  - 2.6. Protocols, Tuples & Generics
  - 2.7. Access Control Levels
- **[3. Memory Management (ARC & Retain Cycles)](./03-ARC-and-Memory-Management.md)**
  - 3.1. What is ARC? ARC vs. Non-ARC (MRC)
  - 3.2. Strong, Weak & Unowned References
  - 3.3. Retain Cycles (Strong Reference Cycles) & Prevention
- **[4. iOS SDK & UIKit (Fundamentals & Advanced)](./04-iOS-SDK-and-UIKit.md)**
  - 4.1. Application Lifecycle, AppDelegate & SceneDelegate
  - 4.2. ViewController Lifecycle
  - 4.3. Passing Data & Navigation
  - 4.4. Views, Frame vs. Bounds, Auto Layout, UIStackView & Custom Views
  - 4.5. UITableView & UICollectionView (Basics & Advanced)
  - 4.6. Animation & Core Graphics
- **[5. Data Persistence & iOS File System](./05-Persistence-and-File-System.md)**
  - 5.1. iOS App Sandbox Directory Structure
  - 5.2. CRUD & Storage Options (DBMS) on iOS
  - 5.3. Core Data Stack & SQL Comparison
  - 5.4. Realm Database
- **[6. Concurrency & Multithreading (GCD, OperationQueue, Swift Concurrency)](./06-Concurrency-GCD-Operation-AsyncAwait.md)**
  - 6.1. Fundamental Concurrency Concepts
  - 6.2. Grand Central Dispatch (GCD)
  - 6.3. Operation & OperationQueue
  - 6.4. Modern Swift Concurrency (`async/await`, `Task`, `TaskGroup`, `Actor`)
- **[7. Software Architecture & Design Patterns](./07-Architecture-and-Design-Patterns.md)**
  - 7.1. Design Patterns Overview (Singleton, Delegation, Observer)
  - 7.2. iOS Architecture Patterns (MVC, MVP, MVVM, VIPER & Clean Swift)
- **[8. Networking, Security, RxSwift, Debugging & Unit Testing](./08-Networking-RxSwift-Debug-UnitTest.md)**
  - 8.1. Networking, JSON Parsing (`Codable`) & Token Security
  - 8.2. Reactive Programming with RxSwift
  - 8.3. Push Notifications, Maps & Git (`merge` vs. `rebase`)
  - 8.4. Debugging & Unit Testing in Xcode

### Part II: Practical Exercises, Live Coding & Algorithms

- **[9. Practical Exercises, Live Coding & Algorithms](./09-Practical-Exercises-and-Algorithms.md)**
  - Exercise 1: "CDG Zig" (FizzBuzz Variant)
  - Exercise 2: Most Frequent String in an Array
  - Exercise 3: Most Common Pair of Strings
  - Exercise 4: N-th Fibonacci Number
  - Exercise 5: Key Combo Matching (`SpecialActions.matchKeyCombo`)
  - Exercise 6: Reptile Egg Hatching System (`Reptile` / `FireDragon` / `ReptileEgg`)
  - Exercise 7: Identify & Fix Retain Cycle (Memory Leak) Between Class A and Class B
  - Exercise 8: Code Reading — Value Types & Copy-on-Write in Swift `Array`
  - Exercise 9: Code Reading — Higher-Order Functions (`sorted` + `map`) on Array of Tuples & Dictionary
  - Exercise 10: Operator Precedence & Short-Circuit Boolean Logic
  - Exercise 11: Classic Algorithms in iOS Interviews (Sorting, Binary Search, Boyer-Moore Majority Vote, Substring Search, Shortest Path)

---

## Directory Structure

- [My iOS Handbook.md](./My%20iOS%20Handbook.md) — Central Table of Contents.
- [01-OOP-and-SOLID.md](./01-OOP-and-SOLID.md) — Object-Oriented Programming & SOLID Principles.
- [02-Swift-Core.md](./02-Swift-Core.md) — Swift Language Core Concepts.
- [03-ARC-and-Memory-Management.md](./03-ARC-and-Memory-Management.md) — ARC, `weak`, `unowned`, and Retain Cycles.
- [04-iOS-SDK-and-UIKit.md](./04-iOS-SDK-and-UIKit.md) — Lifecycles, UIKit, Auto Layout, TableView/CollectionView & Animation.
- [05-Persistence-and-File-System.md](./05-Persistence-and-File-System.md) — Sandbox, Core Data, SQLite & Realm.
- [06-Concurrency-GCD-Operation-AsyncAwait.md](./06-Concurrency-GCD-Operation-AsyncAwait.md) — GCD, `OperationQueue` & Swift Concurrency.
- [07-Architecture-and-Design-Patterns.md](./07-Architecture-and-Design-Patterns.md) — Design Patterns & iOS App Architectures.
- [08-Networking-RxSwift-Debug-UnitTest.md](./08-Networking-RxSwift-Debug-UnitTest.md) — Networking, Security, RxSwift, Debugging & Testing.
- [09-Practical-Exercises-and-Algorithms.md](./09-Practical-Exercises-and-Algorithms.md) — Coding Challenges, Debugging Puzzles & Classic Algorithms.
- [images/](./images/) — Diagrams and screenshots extracted from original interview sheets.
