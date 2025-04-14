//
//  CounterService.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation

protocol CounterService: Sendable {

    func generateRandomNumber() async -> Int

    func numberFact(for number: Int) async -> String?

}
