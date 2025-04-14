//
//  CounterAction.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation

enum CounterAction: Sendable {

    case increment
    case decrement
    case random
    case setCount(Int)
    case setAlertPresented(Bool)

}
