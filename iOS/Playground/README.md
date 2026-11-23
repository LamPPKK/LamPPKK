[← Back to My iOS Handbook](../My%20iOS%20Handbook.md)

---

# Swift Playgrounds — Learning Curriculum & Topic Examples

This workspace is organized into two standalone sets of Swift playgrounds grouped by topic so each playground can be opened in **Xcode** or executed independently via **Terminal (`swift Contents.swift`)**.

## Directory Structure

```text
Playground/
├── README.md
├── 01_Curriculum/          # Modern Swift Curriculum (21 standalone lessons + exercises)
│   ├── 01_Fundamentals/
│   ├── 02_OOP_And_Types/
│   ├── 03_Advanced_Swift/
│   └── 04_Capstone/
└── 02_Examples/            # Topic-focused examples & practice exercises (22 playgrounds)
    ├── 01_Fundamentals/
    ├── 02_OOP_And_Protocols/
    ├── 03_Advanced_Swift/
    └── 04_Exercises/
```

---

## 1. `01_Curriculum/` — Modern Swift Curriculum (21 Standalone Lessons)

Split into 21 self-contained playgrounds, each including conceptual notes, runnable examples, and practice exercises:

### `01_Fundamentals/`
| # | Playground | Key Topics |
|---|---|---|
| 01 | `01_Variables_Constants_BasicTypes.playground` | `var`, `let`, basic types, explicit conversions, `typealias` |
| 02 | `02_Operators.playground` | Arithmetic, comparison, logical, ternary `?:`, `??`, ranges |
| 03 | `03_Strings_Characters.playground` | Interpolation, multiline strings, `String.Index` |
| 04 | `04_Tuples_Collections.playground` | `Tuple`, `Array`, `Set`, `Dictionary` |
| 05 | `05_Conditionals_PatternMatching.playground` | `if`/`switch` expressions, range/tuple matching, `where` |
| 06 | `06_Loops_ControlTransfer.playground` | `for-in`, `stride`, `while`, `repeat-while`, labeled `break` |
| 07 | `07_Optionals.playground` | `if let`, `guard let`, `??`, optional chaining `?.` |
| 08 | `08_Functions.playground` | Argument labels, default values, variadic parameters, `inout`, function types |

### `02_OOP_And_Types/`
| # | Playground | Key Topics |
|---|---|---|
| 09 | `09_Closures_HigherOrderFunctions.playground` | Capturing, `@escaping`, `map`, `compactMap`, `flatMap`, `filter`, `reduce` |
| 10 | `10_Enumerations.playground` | `CaseIterable`, raw values, associated values, `if case let` |
| 11 | `11_Struct_vs_Class.playground` | Value types vs reference types, `===`, `mutating` |
| 12 | `12_Properties_Methods_Subscripts.playground` | `lazy`, computed properties, `willSet`/`didSet`, `static`, `subscript` |
| 13 | `13_Initialization_Inheritance_Deinit.playground` | `init`, `convenience init`, `init?`, `override`, `final`, `deinit` |
| 14 | `14_TypeCasting_Any.playground` | `is`, `as?`, `as!`, `Any`, `AnyObject` |
| 15 | `15_Protocols_Extensions_Delegate_Codable.playground` | POP, default implementations, delegate (`weak`), `Codable` JSON |

### `03_Advanced_Swift/`
| # | Playground | Key Topics |
|---|---|---|
| 16 | `16_ErrorHandling_Defer_Result.playground` | `Error`, `throws`, `do-try-catch`, `defer`, `Result` |
| 17 | `17_Generics_Opaque_Existential.playground` | Generic functions, `Stack<Element>`, `some` & `any` |
| 18 | `18_ARC_MemoryManagement.playground` | ARC, `weak`, `[weak self]`, preventing retain cycles |
| 19 | `19_AccessControl.playground` | `open`, `public`, `internal`, `fileprivate`, `private`, `private(set)` |
| 20 | `20_SwiftConcurrency.playground` | `async`/`await`, `async let`, `Task`, `actor` |

### `04_Capstone/`
| # | Playground | Key Topics |
|---|---|---|
| 21 | `21_CapstoneProjects.playground` | Demo project & 3 end-of-course capstone challenges |

---

## 2. `02_Examples/` — Topic Examples & Practice Exercises (22 Playgrounds)

Reorganized, deduplicated, and separated by single topic:

### `01_Fundamentals/`
| # | Playground | Key Topics |
|---|---|---|
| 01 | `01_Basics_Types_Tuples.playground` | Constants, variables, `UInt8`, conversions, `typealias`, `Bool`, tuples, `assert`/`precondition` |
| 02 | `02_Optionals.playground` | Optionals, `if let`, implicitly unwrapped optionals |
| 03 | `03_Collections.playground` | `Array`, `Set` (set operations), `Dictionary` |
| 04 | `04_ControlFlow_And_Functions.playground` | `for-in`, slices, `stride`, tuple `switch` + `where`, `inout` |
| 05 | `05_Closures.playground` | `sorted(by:)`, shorthand syntax, `spellDigits(of:)`, completion handlers |
| 06 | `06_Enumerations.playground` | `CompassPoint`, `TriStateSwitch`, `CaseIterable`, `Barcode`, `rawValue` |

### `02_OOP_And_Protocols/`
| # | Playground | Key Topics |
|---|---|---|
| 07 | `07_Structs_And_Properties.playground` | Stored/computed properties, `mutating self`, struct initializers |
| 08 | `08_Methods_And_ValueVsReference.playground` | `Counter` (`class`) vs `ValueCounter` (`struct`), `LevelTracker` |
| 09 | `09_Subscripts.playground` | `TimesTable`, 2D `Matrix` subscript, `Planet` `static subscript` |
| 10 | `10_Inheritance.playground` | `Vehicle`, `Bicycle`, `SuperBicycle` (`override`, `didSet`) |
| 11 | `11_Initialization.playground` | `Vehicle`/`Bike`/`HoverBoard`, `Food`/`Recipe` (`convenience init`) |
| 12 | `12_OptionalChaining.playground` | `Person`, `Room`, `Address`, `Residence` (chaining & bounds checks) |
| 13 | `13_Protocols_And_Delegation.playground` | `weak` delegate pattern, `Vehicle` extension, `Starship`, `AnyObject` |
| 14 | `14_Extensions.playground` | `Double.dollar`, unit conversions (`km`/`m`/`cm`/`mm`/`ft`) |

### `03_Advanced_Swift/`
| # | Playground | Key Topics |
|---|---|---|
| 15 | `15_ErrorHandling.playground` | `SandwichError`, `VendingMachineError`, `do-try-catch` |
| 16 | `16_TypeCasting.playground` | `Media`/`Movie`/`Song` (`is`/`as?`), `Any` pattern matching |
| 17 | `17_Generics.playground` | `swapTwoValues<T>`, `Stack<Element>` |
| 18 | `18_OpaqueTypes.playground` | `Shape`, `flip(_:) -> some Shape`, `makeTrapezoid() -> some Shape` |
| 19 | `19_Async_Callbacks_And_AsyncAwait.playground` | Callback chaining vs modern `async/await` |

### `04_Exercises/`
| # | Playground | Key Topics |
|---|---|---|
| 20 | `20_String_Array_Exercises.playground` | 14 string and array algorithm exercises (Ques 1–27) |
| 21 | `21_Math_And_Algorithm_Exercises.playground` | Euclidean distance (`hypot`), `FooBar`, `factorial`, `secondLargest` |
| 22 | `22_BankSMSParser.playground` | Parsing and filtering bank transaction notification lines by prefix |

---

## How to Run

* **In Xcode**: Open any `.playground` package directly and click **Run**.
* **In Terminal**:
  ```bash
  swift 01_Curriculum/01_Fundamentals/01_Variables_Constants_BasicTypes.playground/Contents.swift
  ```
