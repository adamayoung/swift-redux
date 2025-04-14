//
//  CounterReducer.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation
import SwiftRedux

struct CounterReducer: Reducer {

    func reduce(_ oldState: CounterState, with action: CounterAction) -> CounterState {
        var state = oldState

        switch action {
        case .increment:
            state.count += 1

        case .decrement:
            state.count -= 1

        case .setCount(let count):
            state.count = count

        case .setAlertPresented(let isPresented):
            state.isAlertPresented = isPresented

        default:
            break
        }

        return state
    }

}
