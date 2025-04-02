//
//  CounterReducer.swift
//  SwiftRedux
//
//  Created by Adam Young on 02/04/2025.
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

        default:
            break
        }

        return state
    }

}
