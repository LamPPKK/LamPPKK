import Foundation

// MARK: - Basic Throwing Function

enum SandwichError: Error {
    case outOfIngredients
}

func makeSandwich(hasIngredients: Bool) throws {
    guard hasIngredients else {
        throw SandwichError.outOfIngredients
    }
    print("Sandwich is ready!")
}

do {
    try makeSandwich(hasIngredients: true)
} catch {
    print("Failed to make sandwich: \(error)")
}

// MARK: - Vending Machine Error Handling

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chip": Item(price: 10, count: 4),
        "Scooby": Item(price: 9, count: 11)
    ]

    var coinsDeposited = 0

    func vend(itemName name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price

        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem

        print("Dispensing \(name)")
    }
}

let favoriteSnacks = [
    "Batman": "Candy Bar",
    "Superman": "Chip"
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemName: snackName)
}

struct PurchasedSnack {
    let name: String

    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemName: name)
        self.name = name
    }
}

let vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 50

for person in ["Batman", "Superman"] {
    do {
        try buyFavoriteSnack(person: person, vendingMachine: vendingMachine)
        print("\(person) bought snack successfully!")
    } catch VendingMachineError.invalidSelection {
        print("Invalid selection.")
    } catch VendingMachineError.outOfStock {
        print("Out of stock.")
    } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
        print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
    } catch {
        print("Unexpected error: \(error).")
    }
}

do {
    let purchased = try PurchasedSnack(name: "Scooby", vendingMachine: vendingMachine)
    print("Purchased via struct: \(purchased.name), remaining coins: \(vendingMachine.coinsDeposited)")
} catch {
    print("Purchase failed: \(error)")
}

