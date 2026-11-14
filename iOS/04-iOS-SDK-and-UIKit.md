[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 3. Memory Management (ARC & Retain Cycles)](./03-ARC-and-Memory-Management.md) | [Next: 5. Data Persistence & iOS File System ›](./05-Persistence-and-File-System.md)

---

# 4. iOS SDK & UIKit (Fundamentals & Advanced)

## 4.1. Application Lifecycle, AppDelegate & SceneDelegate

- **5 States of an iOS App:**

| State | Description |
| :--- | :--- |
| **Not Running** | App has not launched yet or was terminated by the user or system. |
| **Inactive** | App runs in the foreground but is **not currently receiving UI events** (e.g., brief transition state, incoming call, or Notification Center pulled down). |
| **Active** | App runs in the foreground and **receives user events normally**. |
| **Background** | App is not visible on screen but **still executes code** (e.g., audio playback, location updates, or short `beginBackgroundTask` work) before moving to Suspended. |
| **Suspended** | App stays in memory in the background but **executes no code**. System may purge it silently under low memory. |

- **Key `AppDelegate` Lifecycle Methods (pre-iOS 13 & App-level events):**
  1. `application(_:willFinishLaunchingWithOptions:)`: First callback after launch starts.
  2. `application(_:didFinishLaunchingWithOptions:)`: Runs before the app window is shown; used for initial SDK setup (and root `UIWindow` setup in pre-SceneDelegate apps).
  3. `applicationDidBecomeActive(_:)`: `Inactive` -> `Active` (resume tasks/timers, refresh UI).
  4. `applicationWillResignActive(_:)`: `Active` -> `Inactive` (pause games/timers, hide sensitive views).
  5. `applicationDidEnterBackground(_:)`: App left foreground (~5s execution window unless requesting extra time via `beginBackgroundTask`).
  6. `applicationWillEnterForeground(_:)`: Returning from `Background` toward `Active`.
  7. `applicationWillTerminate(_:)`: App is about to be terminated; perform final cleanup.

- **`AppDelegate` vs. `SceneDelegate` (iOS 13+):**
  - **Before iOS 13:** `AppDelegate` handled both application-level lifecycle events and `UIWindow` management.
  - **iOS 13+ (Multi-window support on iPadOS & iOS):** Responsibilities are split:
    - **`AppDelegate`:** Handles **app-wide** events (app launch, push notification registration, and `UISceneSession` lifecycle methods like `configurationForConnecting` and `didDiscardSceneSessions`).
    - **`SceneDelegate`:** Manages **individual UI windows/scenes** (`UIWindowScene`, `UIWindow`) and UI state transitions:
      - `scene(_:willConnectTo:options:)`: Creates `UIWindow`, assigns `rootViewController`, and calls `makeKeyAndVisible()`.
      - `sceneWillEnterForeground(_:)` -> `sceneDidBecomeActive(_:)`
      - `sceneWillResignActive(_:)` -> `sceneDidEnterBackground(_:)`
      - `sceneDidDisconnect(_:)`: Called when a scene is closed/discarded.

- **Lifecycle Execution Order (with `SceneDelegate`):**
  1. **Launch:** `didFinishLaunchingWithOptions` -> `scene(_:willConnectTo:)` -> `VC1.viewDidLoad` -> `VC1.viewWillAppear` -> `sceneWillEnterForeground` -> `sceneDidBecomeActive` -> `VC1.viewDidAppear`.
  2. **Switch to another app:** `sceneWillResignActive` -> `sceneDidEnterBackground`.
  3. **Return to app:** `sceneWillEnterForeground` -> `sceneDidBecomeActive`.
  4. **Force quit app:** `sceneWillResignActive` -> `sceneDidEnterBackground` -> `sceneDidDisconnect` -> `application(_:didDiscardSceneSessions:)` (or `applicationWillTerminate`).

## 4.2. ViewController Lifecycle

| Order | Method | When It Runs & Common Usage |
| :---: | :--- | :--- |
| 1 | `loadView()` | Called **when `view` is accessed while still `nil`**. Creates/loads the root `view` (from Storyboard/XIB or code). *Override only for 100% programmatic root views, and do not call `super.loadView()`.* |
| 2 | `viewDidLoad()` | Called **once** after the view hierarchy is loaded into memory. Ideal for initial UI setup, cell registration, and one-time data loading. *(Note: Auto Layout final bounds may not be finalized yet).* |
| 3 | `viewWillAppear(_:)` | Called **every time** right before the view is added to the window hierarchy and becomes visible. Ideal for refreshing data, updating navigation bar visibility. |
| 4 | `viewWillLayoutSubviews()` / `viewDidLayoutSubviews()` | Called right before/after the view lays out subviews (once Auto Layout geometry is resolved). |
| 5 | `viewDidAppear(_:)` | Called right after the view is visible on screen. Ideal for starting animations, playing video/audio, starting timers, or analytics impressions. |
| 6 | `viewWillDisappear(_:)` | Called before the view is removed from the hierarchy. Ideal for dismissing the keyboard, stopping timers, canceling pending requests, or saving transient state. |
| 7 | `viewDidDisappear(_:)` | Called after the view is completely off-screen. Ideal for tearing down sensors or active observation tasks. |
| 8 | `didReceiveMemoryWarning()` | Called when the system is low on RAM; release caches or recreatable resources. *(Note: `viewDidUnload` was deprecated in iOS 6).* |
| 9 | `deinit` | Called when the ViewController is deallocated (`ARC == 0`). *Note: A VC disappearing from screen (`viewDidDisappear`) does not mean it is deallocated (e.g., it remains on the Navigation stack).* |

- **Common Interview Questions:**
  - **Which is called first: `viewDidLoad` or `viewWillAppear`?** -> `viewDidLoad()` always runs first (once upon loading into memory), while `viewWillAppear(_:)` runs afterward and can fire multiple times across appearances.
  - **Navigation Push (`VC1` -> `VC2`) and Pop (`VC2` -> `VC1`) Order:**
    - Initial load: `VC1.viewDidLoad` -> `VC1.viewWillAppear` -> `VC1.viewDidAppear`.
    - Push `VC2`: `VC2.viewDidLoad` -> `VC1.viewWillDisappear` -> `VC2.viewWillAppear` -> `VC1.viewDidDisappear` -> `VC2.viewDidAppear`.
    - Pop back to `VC1`: `VC2.viewWillDisappear` -> `VC1.viewWillAppear` -> `VC2.viewDidDisappear` -> `VC1.viewDidAppear` -> `VC2.deinit`.

## 4.3. Passing Data & Navigation

- **Passing Data Mechanisms:**

| Mechanism | Relationship | Characteristics & Usage |
| :--- | :---: | :--- |
| **Property / Initializer** | 1 - 1 (Forward) | Pass data from VC A to VC B during initialization or inside `prepare(for:sender:)`. |
| **Delegate (Protocol)** | 1 - 1 (Backward) | Send events/data back from VC B to VC A cleanly via a protocol. Always store as `weak var delegate` to avoid retain cycles. |
| **Closure / Callback** | 1 - 1 (Backward) | Lightweight alternative to Delegation for simple 1-2 event callbacks; remember `[weak self]`. |
| **NotificationCenter** | 1 - Many | Broadcasts notifications (`post`) to any registered observers (`addObserver`) without direct coupling. Remember to remove observers for selector-based registrations. |
| **KVO (Key-Value Observing)** | 1 - Many | Observes changes on `@objc dynamic` properties. Always retain/invalidate `NSKeyValueObservation` tokens or remove observers before deallocation to avoid crashes. |
| **UserDefaults** | Local Key-Value | Persists lightweight settings (`Bool`, `String`, `Int`) across app launches. Never store sensitive tokens or large datasets here. |

- **Delegate vs. DataSource:**
  - **Delegate:** Handles **events, actions, and behavior** (e.g., `tableView(_:didSelectRowAt:)`).
  - **DataSource:** Supplies **data** required to populate the UI (e.g., `tableView(_:numberOfRowsInSection:)`, `tableView(_:cellForRowAt:)`).
- **Primary Navigation Controllers:**
  - **`UINavigationController`:** Stack-based (LIFO) hierarchical navigation via `pushViewController` / `popViewController`.
  - **`UITabBarController`:** Parallel top-level tab switching via a bottom tab bar.
  - **Modal Presentation:** Presents a view controller modally using `present(_:animated:)` and dismisses via `dismiss(animated:)`.
  - **Storyboard & Segues:** Visual interface linking screens with `Segue` transitions (`performSegue(withIdentifier:sender:)`).

## 4.4. Views, Frame vs. Bounds, Auto Layout, UIStackView & Custom Views

- **UIView & Points:** `UIView` is the base visual building block that draws content and manages subviews. UIKit measures geometry in **Points** (mapped to pixels using screen scale `@1x`, `@2x`, `@3x`).
- **`Frame` vs. `Bounds`:**
  - **`frame`:** A view's origin `(x, y)` and size `(width, height)` relative to its **superview's coordinate system**. Used for positioning a view within its parent or adjusting external layout size.
  - **`bounds`:** A view's origin `(x, y)` (default `(0, 0)`) and size `(width, height)` in **its own local coordinate system**.
  - **Key Subtlety:**
    1. Changing `bounds.origin` (how `UIScrollView` works) shifts the visible viewport over its subviews.
    2. When applying a **transform** (e.g., rotation or scaling), **`frame` changes** to represent the enclosing axis-aligned bounding box, while **`bounds` preserves the true untransformed dimensions** of the view.
- **Auto Layout & Broken Constraints:**
  - Dynamically calculates the size and position of all views in the hierarchy based on constraints across screen sizes.
  - `NSLayoutConstraint` linear equation:
    $$\text{item1.attribute1} = \text{multiplier} \times \text{item2.attribute2} + \text{constant}$$
  - Programmatic constraints commonly use **`NSLayoutAnchor`** (e.g., `view.topAnchor.constraint(equalTo: ...)`).
  - **"Broken" Constraints:** Occur when conflicting constraints cannot be satisfied simultaneously (e.g., two required `1000`-priority width constraints with different constants). UIKit breaks one constraint to resolve the system and logs `Unable to simultaneously satisfy constraints`.
- **`UIStackView`:** Arranges `arrangedSubviews` along a line using 4 key properties:
  - `axis`: `.vertical` or `.horizontal`.
  - `alignment`: Alignment **perpendicular** to the axis (`.fill`, `.leading`, `.center`, `.trailing`, etc.).
  - `distribution`: Sizing/spacing **along** the axis (`.fill`, `.fillEqually`, `.fillProportionally`, `.equalSpacing`, `.equalCentering`).
  - `spacing`: Gap between adjacent arranged subviews.
- **Custom Views:** Reusable custom `UIView` subclasses built in two main ways:
  1. **Programmatic (Code-only):** Subclass `UIView`, override `init(frame:)`, build subviews and constraints in code.
  2. **XIB + Class:** Design layout in `.xib`, link File's Owner or root view, and load via `Bundle.main.loadNibNamed(...)` inside `init(frame:)` and `init?(coder:)`.

## 4.5. UITableView & UICollectionView (Basics & Advanced)

- **`UITableView` vs. `UICollectionView`:**

| Feature | `UITableView` | `UICollectionView` |
| :--- | :--- | :--- |
| **Scroll Direction** | **Vertical** only. | **Vertical, horizontal**, or both. |
| **Columns & Layout** | Single column; cell width spans the table width. | Multi-column, grids, carousels, or completely custom layouts (`UICollectionViewLayout` / `CompositionalLayout`). |
| **Built-in Separators** | Built-in row separators supported. | No built-in separators (must draw manually if needed). |
| **Supplementary Views** | Section Headers/Footers & Table Header/Footer. | `UICollectionReusableView` for headers, footers, and decoration views. |

- **Cell Dequeue / Reuse Mechanism (`dequeueReusableCell(withIdentifier:for:)`):**
  - **How it works:** Instead of instantiating 1,000 cells for 1,000 items, the table/collection view creates only enough cells to fill the visible viewport (plus a small buffer). As cells scroll off-screen, they enter a reuse pool and are recycled for newly appearing rows.
  - **Benefits:** Minimizes RAM footprint (preventing memory spikes/crashes), reduces view/layer creation overhead, and keeps scrolling smooth at 60/120 fps.
  - **Common Bug & Fix:** During fast scrolling with asynchronous image downloads, a recycled cell may briefly display stale images/data from a previous row.
    - *Fix:* Override **`prepareForReuse()`** on the cell subclass to reset UI state (`imageView.image = nil`) and cancel any in-flight image task, and verify the cell still matches the requested `indexPath` / URL upon completion.
  - Note: Always register cells beforehand via `register(_:forCellReuseIdentifier:)` or configure the Reuse Identifier in Storyboard.

- **Advanced Techniques:**
  - **Pull to Refresh:** Attach `UIRefreshControl` to `tableView.refreshControl`.
  - **Batch Updates (Insert / Delete / Reload):** Wrap updates inside `beginUpdates()` ... `endUpdates()` or `performBatchUpdates` (or use `DiffableDataSource` in modern iOS). Always update the backing data source array to match row counts before inserting/deleting rows to avoid `NSInternalInconsistencyException`.
  - **Swipe to Delete:** Implement `trailingSwipeActionsConfigurationForRowAt` (or `commit editingStyle`).
  - **Multi-type Cells:** Model row types with an `enum`, register multiple identifiers, and `switch` inside `cellForRowAt`.
  - **Custom `UICollectionViewLayout`:** Subclass `UICollectionViewLayout` (or configure `FlowLayout` / `CompositionalLayout`) to customize item frames, headers, and footers.

## 4.6. Animation & Core Graphics
- **`UIView.animate`:** Animates `frame`, `bounds`, `center`, `transform` (scale, rotation, translation), `backgroundColor`, and `alpha`.
  - **Spring Animation:** `UIView.animate(withDuration:delay:usingSpringWithDamping:initialSpringVelocity:...)` adds natural bounce/spring physics.
  - **`UIView.animateKeyframes`:** Chains multiple keyframe animation stages across relative time slices.
- **Core Animation Timing Curves:**
  - `curveEaseIn`: Starts slow, accelerates.
  - `curveEaseOut`: Starts fast, decelerates at the end.
  - `curveEaseInOut`: Slow start, fast middle, slow end.
  - `curveLinear`: Constant speed throughout.
- **Core Graphics:** 2D geometry primitives (`CGPoint`, `CGSize`, `CGRect`) and custom vector/canvas drawing inside `draw(_ rect: CGRect)`.

---

[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 3. Memory Management (ARC & Retain Cycles)](./03-ARC-and-Memory-Management.md) | [Next: 5. Data Persistence & iOS File System ›](./05-Persistence-and-File-System.md)
