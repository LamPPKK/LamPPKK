[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 5. Data Persistence & iOS File System](./05-Persistence-and-File-System.md) | [Next: 7. Software Architecture & Design Patterns ›](./07-Architecture-and-Design-Patterns.md)

---

# 6. Concurrency & Multithreading (GCD, OperationQueue, Swift Concurrency)

## 6.1. Fundamental Concurrency Concepts
- **Process:** A running program instance (e.g., your iOS app) with its own virtual address space. A process contains one or more threads.
- **Thread:** The smallest unit of execution scheduled by the OS. Threads within the same process share Heap memory but maintain separate Stacks.
- **Task:** A discrete unit of work / block of code to execute.
- **Main Thread:** The primary UI thread handling user events and **UIKit / SwiftUI updates**. **Golden Rule:** All UI updates **must** run on the Main Thread; running heavy work (network I/O, large image decoding) on it freezes the UI and risks Watchdog termination.
- **Concurrency vs. Parallelism:**
  - **Concurrency:** Managing and executing multiple tasks with overlapping lifetimes (via time-slicing/context switching on one or more cores).
  - **Parallelism:** Literally executing multiple tasks simultaneously at the exact same instant across multiple CPU cores.
- **Synchronous (`sync`) vs. Asynchronous (`async`):**
  - **`sync`:** **Blocks the calling thread** until the dispatched task finishes before returning control.
  - **`async`:** **Returns control immediately** to the calling thread without waiting for the task to complete.
- **`Thread` vs. `DispatchQueue`:**
  - `Thread` is an OS-level concurrency primitive (expensive to create and manage manually).
  - `DispatchQueue` is GCD's higher-level, thread-safe **FIFO** queue abstraction—you submit tasks to a queue, and GCD automatically manages the underlying thread pool.

## 6.2. Grand Central Dispatch (GCD)
GCD is Apple's low-level C API for managing concurrent operations via **FIFO Dispatch Queues**.

- **Queue Execution Types:**
  - **Serial Queue:** Executes **one task at a time** in FIFO order (next starts only after previous finishes). Frequently used to synchronize shared resources and prevent race conditions.
  - **Concurrent Queue:** Starts tasks in FIFO order but can run **multiple tasks simultaneously** on separate threads; tasks may finish in any order.

- **3 DispatchQueue Categories:**
  1. **`DispatchQueue.main`:** A system-provided **Serial Queue** bound to the Main Thread—used exclusively for UI updates.
  2. **`DispatchQueue.global(qos:)`:** System-provided **Concurrent Queues** running in the background across 5 **Quality of Service (QoS)** priority levels (highest to lowest):
     - `.userInteractive`: Highest priority—work directly impacting immediate UI responsiveness (animations, custom drawing).
     - `.userInitiated`: Tasks triggered directly by the user needing results within seconds (opening a document, button-triggered fetch).
     - `.default`: Falls between `.userInitiated` and `.utility` (default parameter; rarely specified explicitly).
     - `.utility`: Longer-running work typically showing a progress indicator (file downloads, heavy computation).
     - `.background`: Lowest priority—work invisible to the user (backups, syncing, prefetching).
     - *(Plus `.unspecified` for legacy APIs opting out of QoS).*
  3. **Custom Queue:** Developer-created queue via `DispatchQueue(label: "com.app.queue", attributes: .concurrent)`. Without `.concurrent`, a custom queue is **Serial** by default.

- **Synchronization Primitives in GCD:**
  - **`DispatchGroup`:** Aggregates multiple async tasks (even across different queues) and notifies when all finish.
    - Call `group.enter()` before each async task and `group.leave()` upon completion (**`enter` and `leave` counts must match strictly**, or the app crashes/hangs).
    - Use `group.notify(queue: .main) { ... }` for non-blocking completion, or `group.wait()` / `group.wait(timeout:)` to block *(never call `wait()` on the Main Thread)*.
  - **`DispatchWorkItem`:** Wraps a block of work into an object supporting `workItem.cancel()` *(cancels automatically before execution starts; once running, check `workItem.isCancelled` manually)* and `workItem.notify(queue:)`.
  - **`DispatchBarrier` (`flags: .barrier`):** Submitted to a **Custom Concurrent Queue** (never a Global Queue), a barrier waits for prior reads to finish, executes **exclusively (serially)**, and then lets subsequent concurrent tasks resume—ideal for **Multiple Readers / Single Writer** thread safety.
  - **`DispatchSemaphore`:** Caps concurrent access to a resource at $N$ threads. Initialize `DispatchSemaphore(value: N)`, call `semaphore.wait()` before entering, and `semaphore.signal()` when finished.

- **Common Concurrency Hazards & Remedies:**

| Hazard | Description | Remedy |
| :--- | :--- | :--- |
| **Race Condition & Critical Section** | Two or more threads access shared mutable state (*Critical Section*) concurrently with at least one write, corrupting data or crashing. | Mutual exclusion (`NSLock`, `os_unfair_lock`), **Serial Queue**, **Dispatch Barrier**, or Swift **`actor`**. |
| **Deadlock** | Two or more threads/queues wait indefinitely on each other to release resources/locks. Classic bug: calling `DispatchQueue.main.sync { ... }` from the Main Thread! | Never call `.sync` onto the same serial queue you are currently running on; maintain consistent lock ordering; prefer `.async`. |
| **Priority Inversion** | A high-QoS task is blocked waiting for a resource/lock currently held by a low-QoS task, degrading app responsiveness. | Assign appropriate QoS levels and avoid blocking high-priority queues on low-priority work. |

## 6.3. Operation & OperationQueue
- **`Operation`:** An object-oriented abstraction built atop GCD. You never instantiate `Operation` directly; instead use **`BlockOperation`** or **subclass `Operation`** (overriding `main()`).
- **4 Read-Only State Properties:**
  1. `isReady`: Ready to run (all dependencies satisfied).
  2. `isExecuting`: Currently running.
  3. `isFinished`: Completed execution.
  4. `isCancelled`: Cancellation requested via `cancel()`. *(Note: Calling `cancel()` only sets `isCancelled = true`; inside a subclass's `main()`, check `if isCancelled { return }`. Once `isFinished` or `isCancelled`, an operation cannot be restarted).*
- **`OperationQueue`:**
  - `maxConcurrentOperationCount`: Limits concurrent operations (`1` makes it behave serially).
  - `addOperation(_:)` / `addOperations(_:waitUntilFinished:)`: Enqueues operations (automatically removed upon completion).
  - `addDependency(_:)`: Enforces execution order between operations (e.g., Operation B waits until Operation A finishes)—a major advantage over plain GCD.
  - `isSuspended`: Pauses starting new queued operations (`cancelAllOperations()` cancels all pending/running ones).

- **When to choose `GCD` vs. `OperationQueue`?**
  - Use **GCD** for lightweight, straightforward async tasks (network calls followed by UI updates on `.main`).
  - Use **OperationQueue** when you need **complex task dependencies**, `maxConcurrentOperationCount` throttling, **bulk cancellation/suspension**, or KVO state monitoring.

## 6.4. Modern Swift Concurrency (`async/await`, `Task`, `TaskGroup`, `Actor`)
- **`async` / `await`:** Enables writing asynchronous code sequentially and cleanly, eliminating callback pyramids and forgotten completion handlers.
- **`Task`:** Creates an asynchronous unit of execution with built-in cooperative cancellation (`task.cancel()`, `Task.isCancelled`) and priority propagation (`TaskPriority`).
- **`TaskGroup` (`withTaskGroup` / `withThrowingTaskGroup`):** Runs a dynamic number of child tasks concurrently, collects results, and enforces **Structured Concurrency** (automatically canceling child tasks if the parent cancels or throws).
- **`Actor`:** A **Reference Type** providing **state isolation**—only one task may access an actor's mutable state at a time (external callers must `await` across isolation boundaries), eliminating **Data Races** at compile time. (`@MainActor` is a global actor guaranteeing execution on the Main Thread for UI updates).

---

[← Back to My iOS Handbook](./My%20iOS%20Handbook.md) | [‹ Previous: 5. Data Persistence & iOS File System](./05-Persistence-and-File-System.md) | [Next: 7. Software Architecture & Design Patterns ›](./07-Architecture-and-Design-Patterns.md)
