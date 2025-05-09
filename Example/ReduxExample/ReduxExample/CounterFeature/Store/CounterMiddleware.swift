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
        case .random:
            let count = await counterService.generateRandomNumber()
            return .setCount(count)

        case .setCount:
            return .fetchNumberFact

        default:
            return nil
        }
    }

}
