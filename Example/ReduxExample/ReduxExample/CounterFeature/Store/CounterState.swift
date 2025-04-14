//
//  CounterState.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation

struct CounterState: Equatable, Sendable {

    var count: Int
    var fact: String?
    var canDecrement: Bool
    var isAlertPresented: Bool

    init(
        count: Int = 0,
        fact: String? = nil,
        canDecrement: Bool = false,
        isAlertPresented: Bool = false
    ) {
        self.count = count
        self.fact = fact
        self.canDecrement = canDecrement
        self.isAlertPresented = isAlertPresented
    }

}
