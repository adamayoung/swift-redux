//
//  CounterAction.swift
//  AsyncRedux
//
//  Created by Adam Young on 02/04/2025.
//

import Foundation

enum CounterAction: Sendable {

    case increment
    case decrement
    case fetchCounter
    case setCount(Int)

}
