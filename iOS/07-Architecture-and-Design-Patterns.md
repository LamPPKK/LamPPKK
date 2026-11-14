[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 6. Concurrency & Multithreading (GCD, OperationQueue, Swift Concurrency)](./06-Concurrency-GCD-Operation-AsyncAwait.md) | [Next: 8. Networking, Security, RxSwift, Debugging & Unit Testing ›](./08-Networking-RxSwift-Debug-UnitTest.md)

---

# 7. Software Architecture & Design Patterns

## 7.1. Design Patterns Overview
Design patterns are proven reusable solutions to common software design problems, grouped into three categories:
1. **Creational Patterns:** Flexible object creation mechanisms (e.g., **Singleton**, Factory Method, Builder).
2. **Structural Patterns:** Composing objects and classes into larger structures (e.g., Adapter, Decorator, Facade, Composite).
3. **Behavioral Patterns:** Defining communication and responsibility delegation between objects (e.g., **Delegation**, **Observer**, Strategy, Command).

- **Singleton Pattern:**
  - **Definition:** Guarantees a class has **only one instance** throughout the app's lifecycle and provides a single global access point.
  - **Thread-Safe Swift Implementation:**
    ```swift
    final class NetworkManager {
        static let shared = NetworkManager() // Lazy and thread-safe by default in Swift (dispatch_once semantics)
        private init() {} // Prevents external instantiation
    }
    ```
  - **Pros:** Convenient global access (`URLSession.shared`, `UserDefaults.standard`, `NotificationCenter.default`); avoids repeated setup overhead.
  - **Cons:** Introduces global shared state and hidden dependencies, makes **Unit Testing / Mocking difficult**, retains memory for the entire app lifetime, and risks **race conditions** if mutated across threads without synchronization.

## 7.2. iOS Architecture Patterns

### 1. MVC (Model - View - Controller)
- **Components:**
  - **Model:** Data structures, business rules, networking, persistence, parsing.
  - **View:** Visual presentation and user input surfaces (notifies Controller via `IBAction` / `Delegate`).
  - **Controller (`UIViewController`):** Mediator coordinating between Model and View.
- **Properties:** Controllers may hold strong references to Model and View; Model and View must **not** hold strong references back to their Controller (use property observers/notifications or `weak` delegates/IBActions to avoid retain cycles).
- **Pros:** Simple, built into UIKit by default, rapid prototyping for small screens.
- **Cons:** Leads to **"Massive View Controller"** because `UIViewController` becomes tightly coupled to `UIView` lifecycle while accumulating business and networking logic, making **unit testing hard**.

### 2. MVP (Model - View - Presenter)
- **Components:**
  - **Model:** Same as MVC.
  - **View (`UIView` + `UIViewController`):** Strictly handles UI setup and forwards user interactions to Presenter.
  - **Presenter:** Owns presentation logic, talks to Model, and updates View through a **Protocol / Delegate**. **Does not import UIKit.**
- **Pros:** Decouples business/presentation logic from UIKit -> **much easier to unit test** than MVC.
- **Cons:** Requires substantial protocol/delegate boilerplate per screen; Presenter can still grow large if services/use-cases aren't extracted.

### 3. MVVM (Model - View - ViewModel)
- **Components:**
  - **Model:** Same as MVC/MVP.
  - **View (`UIView` / `UIViewController`):** Renders UI and binds to ViewModel state changes.
  - **ViewModel:** Bridge between Model and View; transforms/formats Model data for presentation. **Has zero reference to View and does not import UIKit.**
- **Communication (Data Binding):** ViewModel exposes observable state via **Data Binding** (generic Closure/Box observers, KVO, RxSwift, or **Combine** `@Published` / SwiftUI).
- **Pros:**
  - ViewModels are independent of Views -> **reusable** and **highly unit-testable**; one View can bind to multiple ViewModels.
  - Eliminates much of MVP's protocol boilerplate.
- **Cons:** Reactive data-binding chains (RxSwift/Combine) can be **harder to debug** than MVP's explicit method calls; requires vigilance with `[weak self]` / `DisposeBag` to prevent retain cycles.

### 4. VIPER & Clean Swift (VIP)
- **VIPER's 5 Components:**
  - **V (View):** Displays UI and forwards user events to Presenter.
  - **I (Interactor):** The *"brain"* handling business logic, API/DB calls via Workers/Services, and Entities.
  - **P (Presenter):** Receives raw results from Interactor, formats display data for View, and triggers navigation via Router.
  - **E (Entity):** Plain data models manipulated by Interactor.
  - **R (Router / Wireframe):** Handles **screen navigation** and module assembly.
- **VIPER vs. Clean Swift (VIP):**
  - In **VIPER**, the **Presenter is the central hub** (View <-> Presenter <-> Interactor, Presenter -> Router).
  - In **Clean Swift (VIP)**, data flows in a strict **unidirectional cycle**: **ViewController -> Interactor -> Presenter -> ViewController**, and the **ViewController calls the Router directly** for navigation. Every boundary is protocol-driven, enforcing SRP and DIP.

- **Architecture Comparison Table:**

| Criterion | MVC | MVP | MVVM | VIPER / Clean Swift |
| :--- | :---: | :---: | :---: | :---: |
| **Complexity & Boilerplate** | Low | Medium | Medium | Very High (many files/protocols) |
| **Unit Testability** | Poor | Good | Very Good | Excellent |
| **View Update Mechanism** | Direct from Controller | Protocol / Delegate | Data Binding (Combine/Rx/Closures) | Protocol / Delegate |
| **Navigation Separation** | Inside ViewController | Usually VC/Presenter | Often Coordinator pattern | Dedicated **Router** layer |
| **Best Fit** | Small apps / prototypes | Medium apps | Medium to Large apps (industry standard) | Very large enterprise apps with parallel teams |

---

[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 6. Concurrency & Multithreading (GCD, OperationQueue, Swift Concurrency)](./06-Concurrency-GCD-Operation-AsyncAwait.md) | [Next: 8. Networking, Security, RxSwift, Debugging & Unit Testing ›](./08-Networking-RxSwift-Debug-UnitTest.md)
