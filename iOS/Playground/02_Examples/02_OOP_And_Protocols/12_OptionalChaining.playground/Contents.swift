import Foundation

// MARK: - Optional Chaining

class Person {
    var residence: Residence?
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?

    func identifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if let buildingName = buildingName {
            return buildingName
        } else {
            return nil
        }
    }
}

class Residence {
    var rooms = [Room]()
    var address: Address?

    var numOfRooms: Int {
        return rooms.count
    }

    subscript(i: Int) -> Room {
        get {
            precondition(rooms.indices.contains(i), "Room index out of range")
            return rooms[i]
        }
        set {
            precondition(rooms.indices.contains(i), "Room index out of range")
            rooms[i] = newValue
        }
    }

    func printNumOfRoom() {
        print("The number of rooms is \(numOfRooms)")
    }
}

let address = Address()
address.buildingNumber = "30"
address.street = "Elm Street"

let wayne = Person()
let wayneHouse = Residence()
wayneHouse.rooms.append(Room(name: "Kitchen"))
wayne.residence = wayneHouse
wayne.residence?.address = address

wayne.residence?.printNumOfRoom()
print("First room: \(wayne.residence?[0].name ?? "None")")

if let identifierCount = wayne.residence?.address?.identifier()?.count {
    print("Address identifier character count: \(identifierCount)")
}

