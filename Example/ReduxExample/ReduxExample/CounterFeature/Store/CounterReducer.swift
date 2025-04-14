//
//  CounterReducer.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation
import SwiftRedux

struct CounterReducer: Reducer {

    func reduce(
        _ oldState: CounterState,
        with action: CounterAction
    ) -> CounterState {
        var state = oldState

        switch action {
        case .setCount(let count):
            state.count = count
            state.canDecrement = count > 0

        case .setNumberFact(let fact):
            state.fact = fact

        case .setAlertPresented(let isPresented):
            state.isAlertPresented = isPresented

        default:
            break
        }

        return state
    }

}
