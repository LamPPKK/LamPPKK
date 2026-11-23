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
// MARK: - LESSON 13: INITIALIZATION, INHERITANCE & DEINITIALIZATION
// ============================================================================
/*:
 ## Lesson 13: Initialization (`init`), Class Inheritance & `deinit`
 - **Designated `init`**: Primary initializer ensuring every stored property has a valid initial value.
 - **`convenience init`**: Secondary helper initializer that must delegate to `self.init(...)`.
 - **Failable `init?`**: Returns `nil` when initialization inputs are invalid.
 - In class inheritance: Use `override` to customize inherited behavior, `super` to call the parent implementation, and **`final`** to prevent subclassing or overriding (enabling static dispatch optimization).
 */
printSectionHeader("LESSON 13: INITIALIZATION & INHERITANCE")

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

let scooter = Vehicle(cityCommuterBrand: "Honda")
let evCar = ElectricCar(brand: "VinFast", maxSpeedKmh: 200, batteryCapacityKWh: 87)
print("Base class: \(scooter.describe())")
print("Subclass: \(evCar.describe())")

// Failable Initializer (`init?`)
struct VerifiedEmail {
    let address: String
    init?(address: String) {
        guard address.contains("@"), address.contains(".") else { return nil }
        self.address = address
    }
}
print("Valid init?: \(String(describing: VerifiedEmail(address: "student@swift.org")?.address)) | Invalid: \(String(describing: VerifiedEmail(address: "invalid-email")))")

// MARK: Exercise 13
/*:
 ### 🎯 Exercise 13: Staff Hierarchy (`StaffMember` & `SalesExecutive`)
 1. Create base class `StaffMember` with `id: String`, `fullName: String`, `baseSalary: Double`.
    - Use a failable `init?` returning `nil` if `baseSalary < 0` or `fullName.isEmpty`.
    - Add `func monthlyIncome() -> Double` returning `baseSalary`.
 2. Create subclass `final class SalesExecutive: StaffMember` adding `salesRevenue: Double`, `commissionRate: Double`.
    - `override func monthlyIncome() -> Double` returning `baseSalary + salesRevenue * commissionRate`.
 3. Test instantiating both valid objects and `nil` failure cases.
 */
// Write your solution for Exercise 13 here:
