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
// MARK: - LESSON 14: TYPE CASTING (`is`, `as?`, `as!`, `Any`)
// ============================================================================
/*:
 ## Lesson 14: Type Casting (`is`, `as?`, `as!`, `Any`, `AnyObject`)
 - `is`: Checks whether an instance is of a certain subclass/type (`Bool`).
 - `as?`: Safe **conditional downcast** returning an `Optional`.
 - `as!`: Forced downcast (crashes if the cast fails — avoid when possible).
 - `Any`: Represents an instance of any type (`struct`, `enum`, `class`, closure); `AnyObject`: represents an instance of any `class` type.
 */
printSectionHeader("LESSON 14: TYPE CASTING & ANY")

class Vehicle {
    var brand: String
    var maxSpeedKmh: Int

    init(brand: String, maxSpeedKmh: Int) {
        self.brand = brand
        self.maxSpeedKmh = maxSpeedKmh
    }

    convenience init(cityCommuterBrand: String) {
        self.init(brand: cityCommuterBrand, maxSpeedKmh: 110)
    }

    func describe() -> String {
        "\(brand) (Max \(maxSpeedKmh) km/h)"
    }
}

final class ElectricCar: Vehicle {
    var batteryCapacityKWh: Int

    init(brand: String, maxSpeedKmh: Int, batteryCapacityKWh: Int) {
        self.batteryCapacityKWh = batteryCapacityKWh
        super.init(brand: brand, maxSpeedKmh: maxSpeedKmh)
    }

    override func describe() -> String {
        super.describe() + " - Battery: \(batteryCapacityKWh) kWh ⚡️"
    }
}

let garage: [Vehicle] = [
    Vehicle(cityCommuterBrand: "Yamaha"),
    ElectricCar(brand: "Tesla", maxSpeedKmh: 250, batteryCapacityKWh: 75)
]

for item in garage {
    if item is ElectricCar {
        print("  Detected an electric vehicle using `is`!")
    }
    if let electricCar = item as? ElectricCar {
        print("  Safe downcast `as?` -> \(electricCar.brand) battery: \(electricCar.batteryCapacityKWh) kWh")
    }
}

let mixedPayload: [Any] = [42, "Swift 6", 3.14, true]
for element in mixedPayload {
    switch element {
    case let intVal as Int:
        print("  [Any] Int: \(intVal)")
    case let textVal as String:
        print("  [Any] String: \(textVal)")
    default:
        print("  [Any] Other type: \(element)")
    }
}

// MARK: Exercise 14
/*:
 ### 🎯 Exercise 14: Media Library Classification (`MediaItem`)
 1. Create base class `MediaItem` (`title: String`), and two subclasses:
    - `Movie` (with `director: String`)
    - `Song` (with `artist: String`)
 2. Create `library: [MediaItem]` containing 2 movies and 3 songs mixed together.
 3. Iterate through `library`, count `Movie` and `Song` items using `is`, and use `as?` to print each item's director or artist.
 */
// Write your solution for Exercise 14 here:
