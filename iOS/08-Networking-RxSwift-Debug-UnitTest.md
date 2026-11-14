[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 7. Software Architecture & Design Patterns](./07-Architecture-and-Design-Patterns.md) | [Next: 9. Practical Exercises, Live Coding & Algorithms ›](./09-Practical-Exercises-and-Algorithms.md)

---

# 8. Networking, Security, RxSwift, Debugging & Unit Testing

## 8.1. Networking, JSON Parsing (`Codable`) & Token Security
- **API Requests & JSON Parsing in Swift:**
  - Use `URLSession.shared.dataTask(with:)` (or `try await URLSession.shared.data(for:)`) for HTTP requests (`GET`, `POST`, `PUT`, `DELETE`).
  - **Encoding & Decoding (`Codable`):** `Codable` combines `Encodable` (Swift model -> JSON/Data) and `Decodable` (JSON/Data -> Swift model), powered by `JSONEncoder` / `JSONDecoder` and `CodingKeys` for custom field mapping.
- **Secure Token Handling:**
  - **On iOS:**
    - **Storage:** Store Access Tokens and Refresh Tokens in **iOS Keychain** (hardware-encrypted by iOS—**never store tokens in `UserDefaults`**, which is stored as an unencrypted `.plist`).
    - **Transmission:** Send tokens in the HTTP header `Authorization: Bearer <access_token>` over HTTPS (TLS), optionally paired with SSL Pinning.
    - **Refresh Token Flow:** When a request returns `401 Unauthorized`, synchronize incoming requests (via an `Actor` or lock), call the refresh-token endpoint once, save the new token in Keychain, and retry queued requests; if refreshing fails, log the user out.
  - **On Web (if asked as a follow-up):** Avoid `localStorage` / `sessionStorage` due to **XSS** exposure; prefer **Secure `HttpOnly` Cookies** (inaccessible to JavaScript) paired with CSRF protection, or `Authorization` headers for API clients.

## 8.2. Reactive Programming with RxSwift
- **What is an `Observable`?** An asynchronous **event sequence** emitting values over time. Observables are **immutable**—each operator returns a new `Observable` without mutating the source.
- **When does an `Observable` start and stop?**
  - **Starts (Cold Observable):** Begins executing and emitting events only when at least one `Observer` calls **`.subscribe(...)`**.
  - **Ends:** When it emits **`.completed`** or **`.error`**, or when its `Disposable` is disposed (typically when its `DisposeBag` is deallocated).
- **3 Event Types Emitted by an `Observable`:**
  1. **`next(Element)`:** Delivers a new value to subscribers.
  2. **`error(Error)`:** Emits an error and **immediately terminates** the sequence.
  3. **`completed`:** Signals successful completion and **terminates** the sequence (no further events).
- **Common RxSwift Operator Categories:**
  - **Transformation:** `map` (transform each element), `flatMap` / `flatMapLatest` (project each element into an `Observable` and flatten—`flatMapLatest` cancels prior inner observables, ideal for search-as-you-type).
  - **Filtering:** `filter` (predicate filtering), `take(n)` (first `n` items), `debounce` / `throttle` (rate-limiting input/taps).
  - **Combining:** `merge` (interleave streams of the same type), `zip` (pair elements 1-to-1 across streams), `combineLatest` (emit whenever any stream updates once all have emitted).
  - **Error Handling:** `catch` / `catchError` (recover with fallback observable), `retry` (resubscribe on error), `timeout` (error if no emission within time window).

## 8.3. Push Notifications, Maps & Git
- **Local Notification vs. Remote Push Notification:**
  - **Local Notification:** Scheduled and triggered locally on-device by the app via `UNUserNotificationCenter` (e.g., alarms, reminders)—requires no internet or backend server.
  - **Remote Push Notification:** Sent from your **Backend Server -> APNs (Apple Push Notification service) -> Device** using a `deviceToken` (e.g., chat messages, order alerts)—requires internet and APNs certificates/keys.
- **Map SDKs on iOS:**
  - **`MapKit` (Apple):** Native, free, deeply integrated with iOS/Swift, power-efficient.
  - **`Google Maps SDK` (`GMSMapView`):** Rich POI database and detailed street coverage globally, usage-based API billing.
  - **`Mapbox`:** Extensive visual map style customization and turn-by-turn navigation SDKs.
- **Git (`git merge` vs. `git rebase`):**
  - **`git merge`:** Preserves full branching history of both branches and creates a new **merge commit**. Safe for shared branches (`main`, `develop`), though the commit graph becomes non-linear.
  - **`git rebase`:** Replays your feature branch commits onto the tip of the target branch, creating a clean **linear history**. *Rule: Never rebase commits already pushed to shared/public branches because it rewrites commit hashes.*

## 8.4. Debugging & Unit Testing in Xcode

- **Debugging Tools & Techniques:**
  - **Logging:** `print()`, `OSLog` / `Logger`.
  - **Breakpoints:** Regular breakpoints, **Conditional Breakpoints** (break only when condition is true), **Exception Breakpoints** (pause directly at the throwing line instead of `AppDelegate`), Symbolic & Action Breakpoints (log without pausing).
  - **Essential LLDB Commands:**
    - `po <object>`: Print Object (`debugDescription`).
    - `p <variable>`: Print raw type/value (great for structs and primitives).
    - `expr <variable> = <value>`: Mutate state live at a breakpoint.
    - `bt [number]`: Print stack backtrace.
    - `thread return`: Return early from the current stack frame during debugging.
  - **UI Debugging:** **Debug View Hierarchy** (3D layer inspection for clipped, hidden, or mis-sized views).
  - **Memory Debugging:** **Debug Memory Graph** and Instruments (**Leaks**, **Allocations**) to catch retain cycles.
  - **Network & Database Inspection:** **Charles Proxy** / **Proxyman** / **Wireshark** (HTTP traffic); CoreData Editor / DB Browser for SQLite.

- **Unit Testing (`XCTest` / `Swift Testing`):**
  - **3 Test Types:**
    1. **Functional / Unit Tests:** Verify correctness of isolated units (functions, ViewModels, Models).
    2. **Performance Tests (`measure { ... }`):** Benchmark execution time to catch regressions.
    3. **UI Tests (`XCUITest`):** Simulate real user taps, typing, and scrolling end-to-end.
  - **Test Lifecycle:** `setUp()` (prepare clean state) -> `test...()` (run assertions like `XCTAssertEqual`) -> `tearDown()` (clean up resources).
  - **Qualities of Useful Tests (FIRST):** Fast, Independent, Repeatable, Self-Validating (clearly capable of failing and passing), Timely, and cleanly refactored.
  - **3 Ways to Run Tests in Xcode:**
    1. **Product -> Test** (`Cmd + U`) to run the entire test suite.
    2. Play button in the **Test Navigator** (`Cmd + 6`).
    3. Click the gutter diamond icon next to an individual test class or `test...()` method.

---

[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 7. Software Architecture & Design Patterns](./07-Architecture-and-Design-Patterns.md) | [Next: 9. Practical Exercises, Live Coding & Algorithms ›](./09-Practical-Exercises-and-Algorithms.md)
