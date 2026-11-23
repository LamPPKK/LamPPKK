import Foundation

// MARK: - Generic Function

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var firstInt = 10
var secondInt = 20
swapTwoValues(&firstInt, &secondInt)
print("Swapped Ints: \(firstInt), \(secondInt)")

var firstString = "hello"
var secondString = "world"
swapTwoValues(&firstString, &secondString)
print("Swapped Strings: \(firstString), \(secondString)")

// MARK: - Generic Type (Stack<Element>)

struct Stack<Element> {
    private(set) var items = [Element]()

    var isEmpty: Bool {
        return items.isEmpty
    }

    var peek: Element? {
        return items.last
    }

    mutating func push(_ item: Element) {
        items.append(item)
    }

    @discardableResult
    mutating func pop() -> Element? {
        return items.popLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
print("Top of stack: \(stackOfStrings.peek ?? "empty")")
if let popped = stackOfStrings.pop() {
    print("Popped: \(popped), remaining: \(stackOfStrings.items)")
}

