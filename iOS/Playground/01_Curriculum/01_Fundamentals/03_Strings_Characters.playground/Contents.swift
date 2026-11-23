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
// MARK: - LESSON 03: STRINGS & CHARACTERS
// ============================================================================
/*:
 ## Lesson 03: Strings & Characters
 - **String Interpolation**: Embed variables or expressions inside string literals using `\(expression)`.
 - **Multiline String Literal**: Wrap multi-line text inside triple quotes `"""`.
 - Because Swift `String` handles full Unicode grapheme clusters (such as emojis and combined diacritics), Swift uses `String.Index` instead of integer indexing like `text[0]`.
 */
printSectionHeader("LESSON 03: STRINGS & CHARACTERS")

let firstName = "An"
let lastName = "Nguyen"
let fullName = "\(firstName) \(lastName)"
let welcomeMessage = "Hello \(fullName)! Your name has \(fullName.count) characters."

let multilineMotto = """
    Write clean Swift code,
    Build great Apple apps!
    """

let rawCourseTitle = "  iOS Development with Swift  "
let trimmedTitle = rawCourseTitle.trimmingCharacters(in: .whitespaces)
let updatedTitle = trimmedTitle.replacingOccurrences(of: "iOS", with: "Apple Platforms")
let titleWords = updatedTitle.split(separator: " ")

// Accessing characters safely with String.Index
let brandTag = "Swift🍎"
let firstChar = brandTag[brandTag.startIndex]
let lastChar = brandTag[brandTag.index(before: brandTag.endIndex)]

print(welcomeMessage)
print(multilineMotto)
print("Processed string: '\(updatedTitle)' -> Words: \(titleWords)")
print("First char: \(firstChar), Last char: \(lastChar), Ends with '🍎'? \(brandTag.hasSuffix("🍎"))")

// MARK: Exercise 03
/*:
 ### 🎯 Exercise 03: Normalize Full Name & Generate Email
 Given raw user input: `let rawInputName = "   tran   minh   khoa   "`
 **Requirements**:
 1. Remove extra spaces and split words using `.split(separator: " ")`.
 2. Join them into a capitalized full name (`"Tran Minh Khoa"` — hint: `.capitalized` and `.joined(separator: " ")`).
 3. Generate a lowercase, space-free email address `"tranminhkhoa@company.com"` and print both results.
 */
// Write your solution for Exercise 03 here:
