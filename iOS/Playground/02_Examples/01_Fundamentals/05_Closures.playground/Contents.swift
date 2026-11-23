import Foundation

// MARK: - Closure Expressions with sorted(by:)

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}

let reversedWithFunction = names.sorted(by: backward)
let reversedExplicit = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
let reversedInferred = names.sorted(by: { s1, s2 in s1 > s2 })
let reversedShorthand = names.sorted(by: { $0 > $1 })
let reversedOperator = names.sorted(by: >)
let ascendingOperator = names.sorted(by: <)

print("Descending (function): \(reversedWithFunction)")
print("Descending (explicit): \(reversedExplicit)")
print("Descending (inferred): \(reversedInferred)")
print("Descending (shorthand): \(reversedShorthand)")
print("Descending (operator): \(reversedOperator)")
print("Ascending (operator): \(ascendingOperator)")

// MARK: - Closure Variables & Shorthand Syntax

let greet = { print("Hello from closure!") }
greet()

let add: (Int, Int) -> Int = { (a: Int, b: Int) -> Int in
    return a + b
}
let addShorthand: (Int, Int) -> Int = { $0 + $1 }
let addInferred = { (a: Int, b: Int) -> Int in
    a + b
}

print("add(1, 2) = \(add(1, 2))")
print("addShorthand(1, 2) = \(addShorthand(1, 2))")
print("addInferred(1, 2) = \(addInferred(1, 2))")

// MARK: - Digit Spelling with map (Handling 0 and Negatives)

let digitNames = [
    0: "Zero", 1: "One", 2: "Two", 3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]

func spellDigits(of number: Int) -> String {
    var remaining = abs(number)
    var output = ""
    repeat {
        let digit = remaining % 10
        output = (digitNames[digit] ?? "") + output
        remaining /= 10
    } while remaining > 0

    return number < 0 ? "Minus\(output)" : output
}

let numbers = [0, 16, 58, 510, -42]
let spelledNumbers = numbers.map { spellDigits(of: $0) }
for (number, spelled) in zip(numbers, spelledNumbers) {
    print("\(number) -> \(spelled)")
}

// MARK: - Completion Handler (Trailing Closure)

func getSum(of array: [Int], handler: (Int) -> Void) {
    var sum = 0
    for value in array {
        sum += value
    }
    handler(sum)
}

func doSomething() {
    getSum(of: [16, 756, 442, 6, 23]) { sum in
        print("Completion handler sum = \(sum)")
    }
}

doSomething()

