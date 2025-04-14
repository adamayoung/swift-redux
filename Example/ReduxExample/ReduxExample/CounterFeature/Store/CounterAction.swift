//
//  CounterAction.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation

enum CounterAction: Sendable, Equatable {

    case increment
    case decrement
    case random
    case setCount(Int)
    case fetchNumberFact
    case setNumberFact(String?)
    case setAlertPresented(Bool)

}
