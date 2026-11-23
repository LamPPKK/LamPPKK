import Foundation

// MARK: - Basic Enum & Mutating Method

enum CompassPoint {
    case north
    case south
    case east
    case west
}

var directionToHead = CompassPoint.east
directionToHead = .west
print("Heading: \(directionToHead)")

enum TriStateSwitch {
    case off, low, high

    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}

var ovenLight = TriStateSwitch.low
ovenLight.next()
print("Oven light state: \(ovenLight)")

// MARK: - CaseIterable

enum Robin: CaseIterable {
    case nightwing, redRobin, redHood, damianWayne
}

var currentRobin = Robin.nightwing
currentRobin = .damianWayne
currentRobin = .redHood

switch currentRobin {
case .nightwing:
    print("Name: Dick Grayson")
case .redRobin:
    print("Name: Tim Drake")
case .damianWayne:
    print("Name: Damian Wayne")
default:
    print("Other Robin: \(currentRobin)")
}

for robin in Robin.allCases {
    print("Robin case: \(robin)")
}

// MARK: - Associated Values

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
print("Initial barcode: \(productBarcode)")
productBarcode = .qrCode("IAMBATMAN")

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}

// MARK: - Raw Values & Failable RawValue Initializer

enum RobinName: String {
    case nightwing = "Nightwing"
    case redRobin = "RedRobin"
    case redHood = "RedHood"
    case damianWayne = "DamianWayne"
}

print("Robin raw value: \(RobinName.redHood.rawValue)")

// Intentionally misspelled to verify failable rawValue initializer returns nil
let invalidRobin = RobinName(rawValue: "ReedHood")
print("Lookup 'ReedHood': \(String(describing: invalidRobin))")

enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

let position: Int? = 11
if let position = position, let planet = Planet(rawValue: position) {
    switch planet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("No planet at position \(position.map(String.init) ?? "nil")")
}

