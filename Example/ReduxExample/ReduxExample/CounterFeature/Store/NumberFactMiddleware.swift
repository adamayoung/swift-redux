//
//  NumberFactMiddleware.swift
//  ReduxExample
//
//  Created by Adam Young on 15/04/2025.
//

import Foundation
import SwiftRedux

struct NumberFactMiddleware: Middleware {

    private let counterService: any CounterService

    init(counterService: any CounterService) {
        self.counterService = counterService
    }

    func run(_ state: CounterState, with action: CounterAction) async -> CounterAction? {
        switch action {
        case .fetchNumberFact:
            let fact = await counterService.numberFact(for: state.count)
            return .setNumberFact(fact)

        default:
            return nil
        }
    }

}
