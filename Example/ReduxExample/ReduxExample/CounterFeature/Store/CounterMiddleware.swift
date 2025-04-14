//
//  CounterMiddleware.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation
import SwiftRedux

actor CounterMiddleware: Middleware {

    func run(_ state: CounterState, with action: CounterAction) async -> CounterAction? {
        switch action {
        case .random:
            try? await Task.sleep(for: .milliseconds(Int.random(in: 0...500)))
            guard !Task.isCancelled else {
                return nil
            }

            let count = Int.random(in: 0...500)
            return .setCount(count)

        default:
            return nil
        }
    }

}
