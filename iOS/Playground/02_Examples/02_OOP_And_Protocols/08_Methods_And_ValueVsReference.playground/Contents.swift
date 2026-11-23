import Foundation

// MARK: - Reference Type (Class) vs Value Type (Struct)

class Counter {
    var count: Int = 0

    func increment() {
        count += 1
    }

    func increment(by amount: Int) {
        count += amount
    }

    func reset() {
        count = 0
    }
}

let referenceCounter = Counter()
let referenceAlias = referenceCounter
referenceCounter.increment()
referenceCounter.increment()
referenceCounter.increment()
referenceCounter.increment()
print("Class counter alias count (shared instance): \(referenceAlias.count)")

struct ValueCounter {
    var count = 0

    mutating func increment() {
        count += 1
    }

    mutating func increment(by amount: Int) {
        count += amount
    }

    mutating func reset() {
        count = 0
    }
}

var valueCounter = ValueCounter()
let copiedCounter = valueCounter
valueCounter.increment()
valueCounter.increment()
valueCounter.increment()
valueCounter.increment()
valueCounter.increment()
print("Struct original count: \(valueCounter.count), copied count: \(copiedCounter.count)")

// MARK: - Type Methods & Mutating Methods

struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1

    static func unlock(level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }

    static func isUnlocked(level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }

    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level: level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String

    init(name: String) {
        self.playerName = name
    }

    func complete(level: Int) {
        LevelTracker.unlock(level: level + 1)
        tracker.advance(to: level + 1)
    }
}

let player1 = Player(name: "Batman")
player1.complete(level: 1)
print("Highest unlocked level for \(player1.playerName) is now \(LevelTracker.highestUnlockedLevel)")

let player2 = Player(name: "Superman")
player2.complete(level: 3)
print("Highest unlocked level for \(player2.playerName) is now \(LevelTracker.highestUnlockedLevel)")

