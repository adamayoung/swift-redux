//
//  ExampleCounterService.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation

final class ExampleCounterService: CounterService {

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func generateRandomNumber() async -> Int {
        try? await Task.sleep(for: .milliseconds(Int.random(in: 0...500)))

        return Int.random(in: 0...500)
    }

    func numberFact(for number: Int) async -> String? {
        guard let url = URL(string: "http://numbersapi.com/\(number)/trivia") else {
            return nil
        }

        let data: Data
        do {
            data = try await urlSession.data(from: url).0
        } catch {
            return nil
        }

        let fact = String(data: data, encoding: .utf8)
        return fact
    }

}
