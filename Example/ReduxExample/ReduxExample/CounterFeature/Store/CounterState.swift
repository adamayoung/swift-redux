//
//  CounterState.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation

struct CounterState: Equatable, Sendable {

    var count: Int
    var isAlertPresented: Bool

    init(
        count: Int = 0,
        isAlertPresented: Bool = false
    ) {
        self.count = count
        self.isAlertPresented = isAlertPresented
    }

}
