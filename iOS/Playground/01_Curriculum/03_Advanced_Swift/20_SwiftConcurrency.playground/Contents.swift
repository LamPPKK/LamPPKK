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
// MARK: - LESSON 20: MODERN SWIFT CONCURRENCY
// ============================================================================
/*:
 ## Lesson 20: Modern Swift Concurrency (`async`/`await`, `async let`, `actor`)
 Instead of deeply nested completion handlers, Swift Concurrency makes asynchronous code concise and safe:
 - `async` / `await`: Suspends execution while waiting for background work **without blocking the Main Thread**.
 - `async let`: Launches multiple independent async tasks **in parallel** to reduce total wait time.
 - `actor`: Reference type similar to `class`, but automatically serializes access to its mutable state to eliminate **Data Races**.
 */
printSectionHeader("LESSON 20: SWIFT CONCURRENCY (INITIATING ASYNC TASK)")

func fetchUserProfile(userId: Int) async -> String {
    try? await Task.sleep(nanoseconds: 20_000_000) // Simulated 20ms network delay
    return "User #\(userId): Nguyen Van A"
}

func fetchUserBadges(userId: Int) async -> [String] {
    try? await Task.sleep(nanoseconds: 20_000_000)
    return ["Swift Starter", "Clean Coder", "Bug Hunter"]
}

actor SafeViewCounter {
    private var count = 0
    func increment() -> Int {
        count += 1
        return count
    }
}

#if canImport(PlaygroundSupport)
PlaygroundPage.current.needsIndefiniteExecution = true
#endif

print("⏳ Launched async `Task` (main thread remains non-blocking)...")

Task { @MainActor in
    // Execute both API calls concurrently with `async let`
    async let profileTask = fetchUserProfile(userId: 101)
    async let badgesTask = fetchUserBadges(userId: 101)
    let (profileInfo, badges) = await (profileTask, badgesTask)

    let viewCounter = SafeViewCounter()
    let firstView = await viewCounter.increment()
    let secondView = await viewCounter.increment()

    printSectionHeader("LESSON 20: ASYNC / AWAIT & ACTOR RESULTS")
    print("async let -> \(profileInfo)")
    print("async let -> Badges: \(badges.joined(separator: ", "))")
    print("actor -> Thread-safe counter: call \(firstView) -> call \(secondView)")

    print("\n🎉 Finished running the Swift Concurrency example! Try the exercise below!")

    #if canImport(PlaygroundSupport)
    PlaygroundPage.current.finishExecution()
    #endif
}

// MARK: Exercise 20
/*:
 ### 🎯 Exercise 20: Parallel Weather Fetch & `actor` Cache
 1. Write two async functions simulating network delay (`Task.sleep`):
    - `func fetchTemperature(for city: String) async -> Double`
    - `func fetchAirQualityIndex(for city: String) async -> Int`
 2. Create `actor WeatherCache` with `private var cachedReports: [String: String] = [:]`, plus `func saveReport(_ report: String, for city: String)` and `func getReport(for city: String) -> String?`.
 3. Inside a `Task`, use `async let` to fetch both values concurrently for `"Hanoi"`, format a summary report, store it in `WeatherCache`, and print it.
 */
// Write your solution for Exercise 20 here:

#if !canImport(PlaygroundSupport)
RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.15))
#endif
