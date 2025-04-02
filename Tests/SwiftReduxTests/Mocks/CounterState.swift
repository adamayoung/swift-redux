//
//  CounterState.swift
//  SwiftRedux
//
//  Created by Adam Young on 02/04/2025.
//

import Foundation

struct CounterState: Equatable, Sendable {

    var count: Int

    init(count: Int = 0) {
        self.count = count
    }

}
