import Foundation

// MARK: - Stored Properties & Mutating Self Assignment

struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}

var threeItems = FixedLengthRange(firstValue: 3, length: 3)
threeItems.firstValue = 6
print("threeItems: \(threeItems)")

let fourItems = FixedLengthRange(firstValue: 0, length: 4)
print("fourItems: \(fourItems)")

struct Point {
    var x = 0.0
    var y = 0.0

    mutating func update(x deltaX: Double, y deltaY: Double) {
        self = Point(x: x + deltaX, y: y + deltaY)
    }
}

var fixedPoint = Point(x: 3.0, y: 3.0)
fixedPoint.update(x: 2.0, y: 2.0)
print("Updated point: (\(fixedPoint.x), \(fixedPoint.y))")

// MARK: - Computed Properties & Struct Initializer Delegation

struct Size {
    var width = 0.0
    var height = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()

    init() {}

    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }

    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }

    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}

var square = Rect(origin: Point(x: 0.1, y: 0.1), size: Size(width: 10.0, height: 10.0))
print("Initial square.center is (\(square.center.x), \(square.center.y))")
square.center = Point(x: 3, y: 3)
print("Updated square.origin is now at (\(square.origin.x), \(square.origin.y))")

let basicRect = Rect()
let centerRect = Rect(center: Point(x: 4, y: 4), size: Size(width: 4, height: 4))
print("basicRect: \(basicRect), centerRect: \(centerRect)")

struct Color {
    let red, green, blue: Double

    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    init(white: Double) {
        self.red = white
        self.green = white
        self.blue = white
    }
}

let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)
print("Colors -> magenta: \(magenta), gray: \(halfGray)")

