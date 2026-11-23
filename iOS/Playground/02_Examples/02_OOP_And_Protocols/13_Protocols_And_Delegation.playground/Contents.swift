import Foundation

// MARK: - Delegation Pattern (Weak Delegate to Prevent Retain Cycles)

protocol BossDelegate: AnyObject {
    func passData(data: String) -> String
}

class Boss {
    weak var delegate: BossDelegate?
    var reply: String?
}

class Secretary: BossDelegate {
    func passData(data: String) -> String {
        print("Boss said: \(data)")
        return "Message received, boss!"
    }
}

let boss = Boss()
let secretary = Secretary()
boss.delegate = secretary
boss.reply = boss.delegate?.passData(data: "Hello")

if let reply = boss.reply {
    print("Secretary replied: \(reply)")
}

// MARK: - Protocol & Default Implementation via Extension

protocol Vehicle: CustomStringConvertible {
    var isRunning: Bool { get set }
    var make: String { get set }
    var model: String { get set }
    mutating func start()
    mutating func shutDown()
}

extension Vehicle {
    var makeModel: String {
        return "\(make) \(model)"
    }

    mutating func start() {
        if isRunning {
            print("\(description) is already running")
        } else {
            isRunning = true
            print("\(description) starting now... VROOOOOOOM...")
        }
    }

    mutating func shutDown() {
        if isRunning {
            isRunning = false
            print("\(description) stopping now... stopped")
        } else {
            print("\(description) is already stopped")
        }
    }
}

struct SportCar: Vehicle {
    var make: String
    var model: String
    var isRunning: Bool = false

    var description: String {
        return makeModel
    }
}

class Truck: Vehicle {
    var make: String
    var model: String
    var isRunning: Bool = false

    var description: String {
        return makeModel
    }

    init(make: String, model: String) {
        self.make = make
        self.model = model
    }

    func airHorn() {
        print("TOOOOOOT!")
    }
}

var car = SportCar(make: "Ducanger", model: "1975")
var truck = Truck(make: "Volvo", model: "FH16")

car.start()
car.shutDown()

truck.start()
truck.shutDown()

let listOfVehicles: [Vehicle] = [car, truck]
for vehicle in listOfVehicles {
    if let truck = vehicle as? Truck {
        truck.airHorn()
    }
}

// MARK: - Protocol Conformance with Optional Stored Property

protocol FullyNamed {
    var fullName: String { get }
}

class Starship: FullyNamed {
    var prefix: String?
    var name: String

    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }

    var fullName: String {
        return prefix.map { "\($0) \(name)" } ?? name
    }
}

let enterprise = Starship(name: "Enterprise", prefix: "USS")
let voyager = Starship(name: "Voyager")
print("Starships: \(enterprise.fullName), \(voyager.fullName)")

// MARK: - Class-Only Protocol (AnyObject)

protocol Reusable: AnyObject {
    func performAction()
}

class NonReusable: Reusable {
    func performAction() {
        print("Performing reusable action")
    }
}

let item = NonReusable()
item.performAction()

