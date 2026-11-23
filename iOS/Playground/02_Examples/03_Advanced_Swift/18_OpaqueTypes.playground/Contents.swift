import Foundation

protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int

    func draw() -> String {
        guard size > 0 else { return "" }
        return (1...size)
            .map { String(repeating: "*", count: $0) }
            .joined(separator: "\n")
    }
}

struct FlippedShape<T: Shape>: Shape {
    var shape: T

    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U

    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}

struct Square: Shape {
    var size: Int

    func draw() -> String {
        guard size > 0 else { return "" }
        let line = String(repeating: "*", count: size)
        return Array(repeating: line, count: size).joined(separator: "\n")
    }
}

// MARK: - Opaque Return Types (`some Shape`)

func flip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape)
}

func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = flip(top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}

let smallTriangle = Triangle(size: 3)
print("--- Small Triangle ---")
print(smallTriangle.draw())

let flippedTriangle = flip(smallTriangle)
print("--- Flipped Triangle ---")
print(flippedTriangle.draw())

let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
print("--- Joined Triangles ---")
print(joinedTriangles.draw())

let trapezoid = makeTrapezoid()
print("--- Opaque Trapezoid ---")
print(trapezoid.draw())

