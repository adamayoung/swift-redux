//
//  CounterMiddleware.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation
import SwiftRedux

struct CounterMiddleware: Middleware {

    private let counterService: any CounterService

    init(counterService: any CounterService) {
        self.counterService = counterService
    }

    func run(_ state: CounterState, with action: CounterAction) async -> CounterAction? {
        switch action {
        case .increment:
            let count = state.count + 1
            return .setCount(count)

        case .decrement:
            guard state.count > 0 else {
                return nil
            }

            let count = state.count - 1
            return .setCount(count)

        case .random:
            let count = await counterService.generateRandomNumber()
            return .setCount(count)

        case .setCount:
            return .fetchNumberFact

        case .fetchNumberFact:
            let fact = await counterService.numberFact(for: state.count)
            return .setNumberFact(fact)

        default:
            return nil
        }
    }

}
