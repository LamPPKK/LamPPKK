import Foundation

// MARK: - 1. Euclidean Distance Between Two Points

func distanceBetween(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
    return hypot(x1 - x2, y1 - y2)
}

let dist = distanceBetween(x1: 2.5, y1: 2.8, x2: 3.3, y2: 5.7)
print("Distance: \(dist)")

// MARK: - 2. Swap Two Variables

var a = 5
var b = 8
(a, b) = (b, a)
print("After swap -> a: \(a), b: \(b)")

// MARK: - 3. FooBar (Multiples of 5 and 7)

func fooBar(for number: Int) -> String {
    switch (number.isMultiple(of: 5), number.isMultiple(of: 7)) {
    case (true, true):
        return "FooBar"
    case (true, false):
        return "Foo"
    case (false, true):
        return "Bar"
    case (false, false):
        return "Try Again"
    }
}
print("70 -> \(fooBar(for: 70)), 14 -> \(fooBar(for: 14)), 10 -> \(fooBar(for: 10))")

// MARK: - 4. Safe Recursive Factorial

func factorial(of n: Int) -> Int? {
    guard n >= 0 else { return nil }
    return n == 0 ? 1 : (factorial(of: n - 1).map { n * $0 })
}

if let fact3 = factorial(of: 3) {
    print("The factorial of 3 is \(fact3)")
}

// MARK: - 5. Second Largest Element & Safe Array Queries

func secondLargest(in array: [Int]) -> Int? {
    var largest: Int?
    var second: Int?

    for value in array {
        if largest == nil || value > largest! {
            second = largest
            largest = value
        } else if value < largest!, (second == nil || value > second!) {
            second = value
        }
    }
    return second
}

let sample = [11, 3, 6, 6, 2, 9]
print("Second largest in \(sample): \(String(describing: secondLargest(in: sample)))")

let arrayA = [11, 33, 66, 22, 55, 44, 77]
if let minValue = arrayA.min() {
    print("Min in arrayA: \(minValue)")
}

let arrayB = [11, 22, 33, 44, 55, 66, 77]
if let lastIdx = arrayB.lastIndex(of: 22) {
    print("Last index of 22: \(lastIdx)")
}

