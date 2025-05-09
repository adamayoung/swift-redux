//
//  Store+Binding.swift
//  SwiftRedux
//
//  Created by Adam Young on 25/04/2025.
//

import SwiftUI

extension Store {

    ///
    /// Creates a binding for any property in the store's state.
    ///
    /// - Parameters:
    ///   - extract: The property to bind to.
    ///   - embed: The action to set the property.
    ///
    /// - Returns: A `SwiftUI.Binding` for the property.
    ///
    public func binding<Value>(
        extract: @escaping (State) -> Value,
        embed: @escaping (Value) -> Action
    ) -> Binding<Value> {
        .init(
            get: {
                extract(self.state)
            },
            set: { newValue, transaction in
                let action = embed(newValue)

                withTransaction(transaction) {
                    self.apply(action)
                }

                Task {
                    await self.intercept(action, transaction: transaction, signpostID: nil)
                }
            }
        )
    }
}
