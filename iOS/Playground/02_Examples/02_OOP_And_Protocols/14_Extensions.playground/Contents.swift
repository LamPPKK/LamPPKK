import Foundation

// MARK: - Currency Formatting Extension

extension Double {
    var dollar: String {
        return String(format: "$%0.2f", self)
    }
}

let money = 2.2222
print("Formatted amount: \(money.dollar)")

// MARK: - Unit Conversion Extensions

extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
let threeFeet = 3.0.ft
print("Three feet is \(threeFeet) meters")
let marathonMeters = 42.195.km
print("Marathon distance is \(marathonMeters) meters")

