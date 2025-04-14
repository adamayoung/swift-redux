//
//  CounterStubService.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation

@testable import ReduxExample

final class CounterStubService: CounterService, @unchecked Sendable {

    var generateRandomNumberResult: Int?
    private(set) var generateRandomNumberCalls = 0

    var numberFactResult: String?
    private(set) var numberFactCalls = 0
    private(set) var lastNumberFactNumber: Int?

    init() {}

    func generateRandomNumber() async -> Int {
        generateRandomNumberCalls += 1

        guard let generateRandomNumberResult else {
            fatalError("generateRandomNumberResult not set")
        }

        return generateRandomNumberResult
    }

    func numberFact(for number: Int) async -> String? {
        numberFactCalls += 1
        lastNumberFactNumber = number

        return numberFactResult
    }

}
