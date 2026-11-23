import Foundation

// MARK: - Designated & Convenience Initializers

class Vehicle {
    var numOfWheels = 0

    var description: String {
        return "\(numOfWheels) wheels"
    }
}

class Bike: Vehicle {
    override init() {
        super.init()
        numOfWheels = 2
    }
}

class HoverBoard: Vehicle {
    var color: String

    init(color: String) {
        self.color = color
        super.init()
        numOfWheels = 99
    }

    override var description: String {
        return "\(super.description) in a beautiful \(color)"
    }
}

let hover = HoverBoard(color: "Silver")
let bike = Bike()
print("HoverBoard: \(hover.description)")
print("Bike: \(bike.description)")

class Food {
    var name: String

    init(name: String) {
        self.name = name
    }

    convenience init() {
        self.init(name: "Unnamed")
    }
}

class Recipe: Food {
    var quantity: Int

    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }

    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

let recipe1 = Recipe()
print("Recipe: \(recipe1.name), quantity: \(recipe1.quantity)")

