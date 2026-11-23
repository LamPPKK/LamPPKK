import Foundation

// MARK: - Constants & Variables

let constantValue = 10
print("Constant value: \(constantValue)")

var heroDescription = "batman"
let sidekick: String = "robin"

print("I am \(heroDescription)")
print("I am \(sidekick)")

heroDescription += " and superman"
print("I am \(heroDescription)")

// MARK: - Numeric Bounds & Conversions

let minValue = UInt8.min
let maxValue = UInt8.max
print("UInt8 range: \(minValue)...\(maxValue)")

let three = 3
let fractionalPart = 0.14159
let pi = Double(three) + fractionalPart
let intPi = Int(pi)
print("pi = \(pi), intPi = \(intPi)")

typealias AudioSample = UInt16
let maxAmplitudeFound = AudioSample.min
print("Initial audio sample: \(maxAmplitudeFound)")

// MARK: - Booleans

let isAlive = true
let isHeroModeEnabled = false

if isAlive && isHeroModeEnabled {
    print("Hero mode is active")
} else {
    print("Standard mode is active")
}

// MARK: - Tuples

let http404Error = (404, "Not Found")
let (statusCode, statusMessage) = http404Error
let (justTheStatusCode, _) = http404Error

print("Status code: \(statusCode), message: \(statusMessage)")
print("Status code (ignored message): \(justTheStatusCode)")
print("By index -> \(http404Error.0): \(http404Error.1)")

let http200Status = (statusCode: 200, description: "OK")
print("Named tuple -> \(http200Status.statusCode): \(http200Status.description)")

// MARK: - Assertions & Preconditions

func describeAge(_ age: Int) {
    assert(age >= 0, "Age should be non-negative in debug builds.")

    if age > 10 {
        print("You can play.")
    } else if age >= 0 {
        print("You are under 11.")
    } else {
        assertionFailure("Invalid negative age: \(age)")
    }
}

let age = 3
precondition(age >= 0, "Age cannot be negative.")
describeAge(age)

