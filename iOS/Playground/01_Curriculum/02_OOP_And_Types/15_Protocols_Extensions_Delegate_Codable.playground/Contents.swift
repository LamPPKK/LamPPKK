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
// MARK: - LESSON 15: PROTOCOLS, EXTENSIONS, DELEGATE PATTERN & CODABLE
// ============================================================================
/*:
 ## Lesson 15: Protocols, Extensions, Delegate Pattern & `Codable`
 Swift is famous for **Protocol-Oriented Programming (POP)**:
 - `protocol`: Defines a blueprint of properties (`{ get }`, `{ get set }`) and methods.
 - `extension`: Adds methods or computed properties to existing types (including built-in types like `Int` or `String`), or provides **Default Implementations** for a `protocol`.
 - **Delegate Pattern**: Classic iOS event-passing design pattern (using `weak var delegate` with an `AnyObject`-constrained protocol).
 - **`Codable`**: Standard protocol enabling seamless encoding/decoding between Swift structs/classes and **JSON**!
 */
printSectionHeader("LESSON 15: PROTOCOLS, EXTENSIONS, DELEGATE & CODABLE")

// 15.1 Extending Swift's built-in `Int` type
extension Int {
    var formattedVND: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let numberText = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(numberText) VND"
    }
}

// 15.2 Protocol + Default Implementation via Protocol Extension
protocol Payable {
    var productName: String { get }
    var unitPrice: Int { get }
    func finalPrice() -> Int
}

extension Payable {
    func formattedReceipt() -> String {
        "🧾 \(productName): \(finalPrice().formattedVND)"
    }
}

// 15.3 Conforming to Payable, Codable, and Equatable simultaneously
struct OnlineCourse: Payable, Codable, Equatable {
    let courseCode: String
    let productName: String
    let unitPrice: Int
    let discountPercent: Int

    func finalPrice() -> Int {
        unitPrice * (100 - discountPercent) / 100
    }
}

let swiftCourse = OnlineCourse(courseCode: "SW101", productName: "Mastering Swift", unitPrice: 1_200_000, discountPercent: 20)
print(swiftCourse.formattedReceipt())

// Encode to JSON & Decode back with Codable
if let jsonData = try? JSONEncoder().encode(swiftCourse),
   let jsonString = String(data: jsonData, encoding: .utf8) {
    print("JSON Encoded: \(jsonString)")
    if let decodedCourse = try? JSONDecoder().decode(OnlineCourse.self, from: jsonData) {
        print("JSON Decoded matches original? \(decodedCourse == swiftCourse)")
    }
}

// 15.4 Delegate Pattern (constrained to `AnyObject` so `weak` can be used)
protocol DownloadManagerDelegate: AnyObject {
    func didFinishDownloading(fileName: String)
}

class DownloadManager {
    weak var delegate: (any DownloadManagerDelegate)?

    func startDownload(fileName: String) {
        delegate?.didFinishDownloading(fileName: fileName)
    }
}

class DocumentScreen: DownloadManagerDelegate {
    func didFinishDownloading(fileName: String) {
        print("Delegate Pattern -> Screen notified that download finished: \(fileName)")
    }
}

let screen = DocumentScreen()
let downloader = DownloadManager()
downloader.delegate = screen
downloader.startDownload(fileName: "SwiftHandbook.pdf")

// MARK: Exercise 15
/*:
 ### 🎯 Exercise 15: `Discountable` Protocol & JSON Export
 1. Create `protocol Discountable` with `var originalPrice: Double { get }` and `func priceAfterDiscount(percent: Double) -> Double`.
 2. Write `extension Discountable` providing a default implementation for `priceAfterDiscount(percent:)`.
 3. Create `struct Book: Discountable, Codable` with `isbn: String`, `title: String`, `originalPrice: Double`.
 4. Create a `[Book]` array, compute each book's 15% discounted price, and encode the array to JSON using `JSONEncoder` (`outputFormatting = .prettyPrinted`).
 */
// Write your solution for Exercise 15 here:
