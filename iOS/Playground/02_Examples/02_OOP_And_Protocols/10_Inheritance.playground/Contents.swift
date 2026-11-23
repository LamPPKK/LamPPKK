import Foundation

// MARK: - Inheritance & Overriding

class Vehicle {
    var currentSpeed = 0.0

    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }

    func makeNoise() {
        print("Vroom Vroom")
    }
}

class Bicycle: Vehicle {
    var gear = 1
    var hasBasket = true

    override func makeNoise() {
        print("Ding Ding!")
    }

    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")
bicycle.makeNoise()

class SuperBicycle: Bicycle {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10) + 1
        }
    }
}

let superBike = SuperBicycle()
superBike.currentSpeed = 9999
print("SuperBicycle: \(superBike.description)")

