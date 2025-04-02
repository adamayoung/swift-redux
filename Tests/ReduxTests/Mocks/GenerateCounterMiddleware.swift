//
//  GenerateCounterMiddleware.swift
//  Redux
//
//  Created by Adam Young on 02/04/2025.
//

import Foundation
import Redux

actor GenerateCounterMiddleware: Middleware {

    func run(_ state: CounterState, with action: CounterAction) async -> CounterAction? {
        switch action {
        case .fetchCounter:
            try? await Task.sleep(for: .seconds(1))
            return .setCount(1000)

        default:
            return nil
        }
    }

}
