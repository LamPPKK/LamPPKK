import Foundation

// MARK: - Instance Subscript

struct TimesTable {
    let multiplier: Int

    subscript(index: Int) -> Int {
        return multiplier * index
    }
}

let threeTimesTable = TimesTable(multiplier: 3)
print("3 x 6 = \(threeTimesTable[6])")

// MARK: - Multi-Dimensional Subscript (2D Matrix)

struct Matrix {
    let rows: Int
    let columns: Int
    var grid: [Double]

    init(rows: Int, columns: Int) {
        precondition(rows >= 0 && columns >= 0, "Matrix dimensions must be non-negative")
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: 0.0, count: rows * columns)
    }

    func isValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    subscript(row: Int, column: Int) -> Double {
        get {
            assert(isValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(isValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
matrix[1, 1] = 12
print("matrix[1, 1] = \(matrix[1, 1])")

// MARK: - Type Subscript (Static)

enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune

    static subscript(n: Int) -> Planet? {
        return Planet(rawValue: n)
    }
}

if let mars = Planet[4] {
    print("Planet[4] is \(mars)")
}

