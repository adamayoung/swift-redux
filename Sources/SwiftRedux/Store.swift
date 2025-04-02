//
//  Store.swift
//  SwiftRedux
//
//  Created by Adam Young on 02/04/2025.
//

import Foundation
import Observation

///
/// A store holding state allowing actions to be sent to it.
///
@dynamicMemberLookup
@Observable
@MainActor
public final class Store<State: Equatable & Sendable, Action: Sendable> {

    private var state: State
    private let reducer: any Reducer<State, Action>
    private let middlewares: [any Middleware<State, Action>]

    ///
    /// Initialises a new store.
    ///
    /// - Parameters:
    ///   - initialState: The initial state.
    ///   - reducer: The store's reducer.
    ///   - middlewares: A list of middlewares.
    ///
    public init(
        initialState: State,
        reducer: any Reducer<State, Action>,
        middlewares: [any Middleware<State, Action>] = []
    ) {
        self.state = initialState
        self.reducer = reducer
        self.middlewares = middlewares
    }

    public subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        self.state[keyPath: keyPath]
    }

    ///
    /// Mutates the state of the store with an action.
    ///
    /// - Parameter action: The action to perform.
    ///
    public func send(_ action: Action) async {
        apply(action)
        await intercept(action)
    }

}

extension Store {

    private func apply(_ action: Action) {
        let newState = reducer.reduce(state, with: action)
        if newState != state {
            state = newState
        }
    }

    private func intercept(_ action: Action) async {
        await withDiscardingTaskGroup { group in
            for middleware in middlewares {
                group.addTask {
                    guard let nextAction = await middleware.run(self.state, with: action) else {
                        return
                    }

                    await self.send(nextAction)
                }
            }
        }
    }

}

#if canImport(SwiftUI)
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
                get: { extract(self.state) },
                set: { newValue, transaction in
                    let action = embed(newValue)

                    withTransaction(transaction) {
                        self.apply(action)
                    }

                    Task {
                        await self.intercept(action)
                    }
                }
            )
        }
    }
#endif
