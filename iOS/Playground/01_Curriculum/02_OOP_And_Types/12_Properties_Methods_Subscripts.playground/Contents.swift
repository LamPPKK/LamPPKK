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
// MARK: - LESSON 12: PROPERTIES, METHODS & SUBSCRIPTS
// ============================================================================
/*:
 ## Lesson 12: Properties, Methods & Subscripts
 - **Stored Property**: Stores a value directly on an instance.
 - **`lazy var`**: Initialized **only on first access** (useful for expensive setup).
 - **Computed Property (`get` / `set`)**: Dynamically calculates values on access instead of storing them.
 - **Property Observers (`willSet` / `didSet`)**: React immediately before (`newValue`) and after (`oldValue`) a stored property changes.
 - **`static`**: Type-level properties and methods attached to the type itself rather than an instance.
 - **`subscript`**: Enables bracket syntax `instance[index]` for convenient element access.
 */
printSectionHeader("LESSON 12: PROPERTIES, OBSERVERS, STATIC & SUBSCRIPTS")

struct Rectangle {
    static let shapeType = "Quadrilateral"

    var width: Double {
        willSet {
            print("  [willSet] width changing from \(width) -> \(newValue)")
        }
        didSet {
            print("  [didSet] width changed from \(oldValue) -> \(width)")
        }
    }
    var height: Double

    lazy var metadataDescription: String = {
        "Rectangle Frame (\(width) x \(height))"
    }()

    // Read-only Computed Property
    var area: Double {
        width * height
    }

    // Read-write Computed Property
    var perimeter: Double {
        get { (width + height) * 2 }
        set { height = (newValue / 2) - width }
    }
}

var box = Rectangle(width: 4, height: 5)
print("Shape: \(Rectangle.shapeType) | Area: \(box.area) | Perimeter: \(box.perimeter)")
box.width = 6
print("Lazy property: \(box.metadataDescription)")

struct MultiplicationTable {
    let multiplier: Int
    subscript(number: Int) -> Int {
        multiplier * number
    }
}
let sevenTimesTable = MultiplicationTable(multiplier: 7)
print("Subscript -> 7 x 8 = \(sevenTimesTable[8])")

// MARK: Exercise 12
/*:
 ### 🎯 Exercise 12: `TemperatureSensor`
 Design `struct TemperatureSensor`:
 1. Add `static let maxSafeCelsius: Double = 100.0`.
 2. Add stored property `var celsius: Double` with a `didSet` observer: if `celsius > Self.maxSafeCelsius`, print an overheating warning!
 3. Add computed property `var kelvin: Double` supporting both `get` (`celsius + 273.15`) and `set` (`celsius = newValue - 273.15`).
 4. Set `sensor.kelvin = 400.0` and observe `didSet` automatically triggering the warning!
 */
// Write your solution for Exercise 12 here:
