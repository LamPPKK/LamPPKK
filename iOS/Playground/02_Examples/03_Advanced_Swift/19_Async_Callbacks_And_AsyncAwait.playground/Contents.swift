import Foundation

#if canImport(PlaygroundSupport)
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
#endif

// MARK: - 1. Callback Chaining (Legacy Pattern)

func add(a: Int, b: Int, completion: @escaping @Sendable (Int) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        completion(a + b)
    }
}

func multiply(a: Int, b: Int, completion: @escaping @Sendable (Int) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        completion(a * b)
    }
}

let firstValue = 10
let secondValue = 20

add(a: firstValue, b: secondValue) { sum1 in
    print("[Callback] Sum 1: \(sum1)")
    multiply(a: sum1, b: secondValue) { product1 in
        print("[Callback] Product 1: \(product1)")
        add(a: product1, b: firstValue) { sum2 in
            print("[Callback] Sum 2: \(sum2)")
            multiply(a: sum2, b: 2) { product2 in
                print("[Callback] Final result: \(product2)")
            }
        }
    }
}

// MARK: - 2. Modern async/await Equivalent

func addAsync(a: Int, b: Int) async throws -> Int {
    try await Task.sleep(for: .milliseconds(200))
    return a + b
}

func multiplyAsync(a: Int, b: Int) async throws -> Int {
    try await Task.sleep(for: .milliseconds(200))
    return a * b
}

func runAsyncDemo() async {
    do {
        let sum1 = try await addAsync(a: firstValue, b: secondValue)
        print("[Async] Sum 1: \(sum1)")
        let product1 = try await multiplyAsync(a: sum1, b: secondValue)
        print("[Async] Product 1: \(product1)")
        let sum2 = try await addAsync(a: product1, b: firstValue)
        print("[Async] Sum 2: \(sum2)")
        let finalResult = try await multiplyAsync(a: sum2, b: 2)
        print("[Async] Final result: \(finalResult)")
    } catch {
        print("[Async] Cancelled or failed: \(error)")
    }
}

Task {
    await runAsyncDemo()
}

