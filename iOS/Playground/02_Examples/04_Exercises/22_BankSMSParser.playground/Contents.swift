import Foundation

func parseBankNotification(
    _ message: String,
    excludingPrefixes: [String] = []
) -> [String] {
    return message
        .components(separatedBy: "\n")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { line in
            guard !line.isEmpty else { return false }
            return !excludingPrefixes.contains { prefix in
                line.hasPrefix(prefix)
            }
        }
}

let transferMessage = """
Date: 09/12/2022 14:40
Account: 100009529246
Transaction: -50,000 VND
Service Fee: 0 VND
Balance: +1,042,382 VND
Description: PHAM THU HUONG | PHAM THU HUONG transfer
"""

let transferWithFeeKeywordInContent = """
Date: 09/12/2022 14:40
Account: 100009529246
Transaction: -500,000 VND
Service Fee: 0 VND
Balance: +542,382 VND
Description: Service Fee payment for apartment December
"""

let savingsMessage = """
Date: 06/12/2022 18:00
Traditional savings account opened successfully
Savings Account: 600018584678
Amount: +1,000,000 VND
Term: 7 Days
Interest Rate: 1 %/year
"""

print("=== Transfer ===")
print(parseBankNotification(transferMessage, excludingPrefixes: ["Service Fee:"]))

print("\n=== Transfer (Description contains 'Service Fee') ===")
print(parseBankNotification(transferWithFeeKeywordInContent, excludingPrefixes: ["Service Fee:"]))

print("\n=== Savings ===")
print(parseBankNotification(savingsMessage, excludingPrefixes: ["Term:", "Interest Rate:"]))
