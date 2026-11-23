import Foundation

// Ques 1: Sum of two integers; return triple their sum if they are equal.
func sumOrTriple(x: Int, y: Int) -> Int {
    let sum = x + y
    return x == y ? 3 * sum : sum
}
print("Q1:", sumOrTriple(x: 1, y: 2), sumOrTriple(x: 3, y: 3))

// Ques 2: Absolute difference between n and 51; return double if n > 51.
func absoluteDiffFrom51(n: Int) -> Int {
    let diff = abs(n - 51)
    return n > 51 ? 2 * diff : diff
}
print("Q2:", absoluteDiffFrom51(n: 54), absoluteDiffFrom51(n: 40))

// Ques 3: Return true if either integer is 20 or their sum is 20.
func isTwentyOrSumTwenty(x: Int, y: Int) -> Bool {
    return x == 20 || y == 20 || x + y == 20
}
print("Q3:", isTwentyOrSumTwenty(x: 20, y: 20), isTwentyOrSumTwenty(x: 12, y: 8))

// Ques 4: Return true if at least one of the two integers is negative.
func hasNegative(x: Int, y: Int) -> Bool {
    return x < 0 || y < 0
}
print("Q4:", hasNegative(x: -1, y: -1), hasNegative(x: 1, y: -1), hasNegative(x: 1, y: 1))

// Ques 5: Add "Is" prefix if the string does not already begin with "Is" (case-insensitive).
func addPrefixIs(to str: String) -> String {
    if str.hasPrefix("Is") || str.hasPrefix("is") {
        return str
    }
    return "Is" + str
}
print("Q5:", addPrefixIs(to: "Batman"), addPrefixIs(to: "IsBatman"))

// Ques 6: Remove a character at the given index if valid.
func removeChar(from str: String, at index: Int) -> String {
    guard index >= 0 && index < str.count else { return str }
    var newStr = str
    newStr.remove(at: newStr.index(newStr.startIndex, offsetBy: index))
    return newStr
}
print("Q6:", removeChar(from: "Batman", at: 3), removeChar(from: "Batman", at: -1))

// Ques 7: Swap the first and last characters of a string.
func swapFirstAndLast(in str: String) -> String {
    guard str.count > 1 else { return str }
    var newStr = str
    let firstChar = newStr.removeFirst()
    let lastChar = newStr.removeLast()
    newStr.insert(lastChar, at: newStr.startIndex)
    newStr.append(firstChar)
    return newStr
}
print("Q7:", swapFirstAndLast(in: "Batman"), swapFirstAndLast(in: "A"), swapFirstAndLast(in: ""))

// Ques 8: Prepend and append the last character of a non-empty string.
func wrapWithLastChar(_ str: String) -> String {
    guard let lastChar = str.last else { return str }
    return "\(lastChar)\(str)\(lastChar)"
}
print("Q8:", wrapWithLastChar("Batman"), wrapWithLastChar("A"), wrapWithLastChar(""))

// Ques 9: Check whether a non-negative integer is a multiple of 3 and/or 5.
func checkMultipleOf3Or5(_ x: Int) {
    guard x >= 0 else {
        print("\(x) is negative")
        return
    }
    if x.isMultiple(of: 3) && x.isMultiple(of: 5) {
        print("\(x) is a multiple of both 3 and 5")
    } else if x.isMultiple(of: 3) {
        print("\(x) is a multiple of 3")
    } else if x.isMultiple(of: 5) {
        print("\(x) is a multiple of 5")
    } else {
        print("\(x) is not a multiple of 3 or 5")
    }
}
checkMultipleOf3Or5(-1)
checkMultipleOf3Or5(0)
checkMultipleOf3Or5(3)
checkMultipleOf3Or5(4)
checkMultipleOf3Or5(5)
checkMultipleOf3Or5(15)

// Ques 19: Uppercase the last 3 characters (or lowercase whole string if length < 3).
func uppercaseLastThree(_ str: String) -> String {
    guard str.count >= 3 else {
        return str.lowercased()
    }
    let prefixPart = str.dropLast(3)
    let suffixPart = str.suffix(3).uppercased()
    return prefixPart + suffixPart
}
print("Q19:", uppercaseLastThree("Batman and robin"), uppercaseLastThree("Hi"))

// Ques 20: Return true if the first occurrence of "a" is immediately followed by another "a".
func isFirstAFollowedByA(in str: String) -> Bool {
    var index = str.startIndex
    while index < str.endIndex {
        let nextIndex = str.index(after: index)
        if str[index] == "a" {
            return nextIndex < str.endIndex && str[nextIndex] == "a"
        }
        index = nextIndex
    }
    return false
}
print("Q20:", isFirstAFollowedByA(in: "baatman"), isFirstAFollowedByA(in: "batman"), isFirstAFollowedByA(in: "a"))

// Ques 24: Return true if the array contains three consecutive increasing integers (e.g. 1, 2, 3).
func hasThreeConsecutiveIncreasing(in arr: [Int]) -> Bool {
    guard arr.count >= 3 else { return false }
    for i in 2..<arr.count {
        if arr[i - 2] + 1 == arr[i - 1] && arr[i - 1] + 1 == arr[i] {
            return true
        }
    }
    return false
}
print("Q24:", hasThreeConsecutiveIncreasing(in: [0, 2, 3, 3, 4, 2, 3, 66]), hasThreeConsecutiveIncreasing(in: [1, 2, 3]))

// Ques 26: Build a new string from characters at even indices (0, 2, 4, ...).
func charactersAtEvenIndices(in str: String) -> String {
    var result = ""
    for (offset, char) in str.enumerated() where offset.isMultiple(of: 2) {
        result.append(char)
    }
    return result
}
print("Q26:", charactersAtEvenIndices(in: "Batman"))

// Ques 27: Count adjacent pairs of 7s in an integer array.
func countAdjacentSevens(in arr: [Int]) -> Int {
    var count = 0
    for i in 1..<max(1, arr.count) {
        if arr[i - 1] == 7 && arr[i] == 7 {
            count += 1
        }
    }
    return count
}
print("Q27:", countAdjacentSevens(in: [1, 2, 3, 4, 5, 7, 7]), countAdjacentSevens(in: [7, 7, 7]))

