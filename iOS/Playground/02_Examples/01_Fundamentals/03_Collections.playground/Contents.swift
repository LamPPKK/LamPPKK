import Foundation

// MARK: - Arrays

var intArray = [Int]()
let intArray2 = [1, 2, 3]
let stringArray: [String] = ["Batman", "Superman"]
let intArrayCombine = intArray2 + intArray
intArray = intArray2
print("intArray: \(intArray), combined: \(intArrayCombine), stringArray: \(stringArray)")

let repeatedHeroes = Array(repeating: "Batman", count: 6)
print("repeatedHeroes count: \(repeatedHeroes.count), intArray2 count: \(intArray2.count)")
print("Element at index 3: \(repeatedHeroes[3])")

var heroes = ["Batman", "Superman"]
heroes += ["Green Lantern", "Aquaman", "Cyborg", "Wonder Woman"]
heroes += ["Flash"]
heroes[2...] = ["Martian Manhunter"]
heroes.insert("Zatanna", at: 0)

print("Heroes inline: ", terminator: "")
for hero in heroes {
    print(hero, terminator: " ")
}
print()

for (index, value) in heroes.enumerated() {
    print("\(index + 1): \(value)")
}

// MARK: - Sets

var favoriteHeroes: Set<String> = ["Batman", "Superman", "Wonder Woman"]
favoriteHeroes.insert("Flash")
print("After insert: \(favoriteHeroes)")
favoriteHeroes.remove("Batman")
print("After remove Batman: \(favoriteHeroes)")
favoriteHeroes.remove("Green Arrow")

for hero in favoriteHeroes.sorted() {
    print("Sorted hero: \(hero)")
}

let odd: Set = [1, 3, 5, 7, 9]
let even: Set = [2, 4, 6, 8, 10]
let random: Set = [1, 2, 3, 4, 5, 6]

print("Intersection: \(odd.intersection(even).sorted())")
print("Union: \(odd.union(even).sorted())")
print("Symmetric difference: \(odd.symmetricDifference(even).sorted())")
print("Subtracting: \(odd.subtracting(random).sorted())")

// MARK: - Dictionaries

var heroesRanks = [Int: String]()
heroesRanks[1] = "Superman"
print("heroesRanks: \(heroesRanks)")

var heroesRanks2: [Int: String] = [1: "Superman", 2: "Batman", 3: "Flash"]
if let oldValue = heroesRanks2.updateValue("Green Lantern", forKey: 2) {
    print("Replaced rank 2 value: \(oldValue)")
}

heroesRanks2.removeValue(forKey: 3)
if let rank2Hero = heroesRanks2[2] {
    print("Current rank 2 hero: \(rank2Hero)")
}

for hero in heroesRanks2.values {
    print("Dictionary hero: \(hero)")
}

