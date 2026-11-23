import Foundation

// MARK: - Optionals & Optional Binding

var optionalNumber: Int?
optionalNumber = nil
optionalNumber = 999

if let unwrappedNumber = optionalNumber {
    print("optionalNumber is not nil, unwrapped: \(unwrappedNumber)")
} else {
    print("optionalNumber is nil")
}

let someOptional: Int? = 100
if let boundValue = someOptional {
    print("someOptional = \(boundValue)")
} else {
    print("nothing")
}

// MARK: - Implicitly Unwrapped Optionals

let possibleString: String? = "An optional string."
if let safeString = possibleString {
    print(safeString)
}

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString
print(implicitString)

