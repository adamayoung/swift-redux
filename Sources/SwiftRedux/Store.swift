//
//  Store.swift
//  SwiftRedux
//
//  Created by Adam Young on 02/04/2025.
//

import Foundation
import Observation
import SwiftUI
import os

///
/// A store holding state allowing actions to be sent to it.
///
@dynamicMemberLookup
@Observable
@MainActor
public final class Store<State: Equatable & Sendable, Action: Sendable> {

    var state: State
    let reducer: any Reducer<State, Action>
    let middlewares: [any Middleware<State, Action>]
    private let logger: Logger?
    private let signposter: OSSignposter?

    ///
    /// Initialises a new store.
    ///
    /// - Parameters:
    ///   - initialState: The initial state.
    ///   - reducer: The store's reducer.
    ///   - middlewares: A list of middlewares.
    ///   - logger: Optional logger.
    ///
    public init(
        initialState: State,
        reducer: any Reducer<State, Action>,
        middlewares: [any Middleware<State, Action>] = [],
        logger: Logger? = nil
    ) {
        self.state = initialState
        self.reducer = reducer
        self.middlewares = middlewares
        self.logger = logger
        self.signposter = {
            guard let logger else {
                return nil
            }

            return OSSignposter(logger: logger)
        }()
    }

    ///
    /// - Parameter dynamicMember: Key path for state value.
    ///
    /// - Returns: Value of state.
    ///
    public subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        self.state[keyPath: keyPath]
    }

}

extension Store {

    ///
    /// Sends an action to the store.
    ///
    /// - Parameter action: The action to perform.
    ///
    public func send(_ action: Action) async {
        await send(action, transaction: nil)
    }

    ///
    /// Sends an action to the store with a given animation.
    ///
    /// - Parameters:
    ///   - action: The action to perform.
    ///   - animation: An animation.
    ///
    public func send(_ action: Action, animation: Animation?) async {
        let transaction = Transaction(animation: animation)
        await send(action, transaction: transaction)
    }

    ///
    /// Sends an action to the store with a given transaction.
    ///
    /// - Parameters:
    ///   - action: The action to perform.
    ///   - transaction: A transaction.
    ///
    public func send(_ action: Action, transaction: Transaction?) async {
        let label = String(describing: action)
        let signpostID = signposter?.makeSignpostID()
        let signpostIntervalState: OSSignpostIntervalState?
        let signpostIntervalName: StaticString = "Send action"

        if let signposter, let signpostID {
            signpostIntervalState = signposter.beginInterval(
                signpostIntervalName,
                id: signpostID,
                "\(label)"
            )
        } else {
            signpostIntervalState = nil
        }

        let traceID = StoreContext.actionTraceID ?? UUID()

        let start = Date()
        await StoreContext.$actionTraceID.withValue(traceID) {
            await StoreContext.$actionDepth.withValue(StoreContext.actionDepth + 1) {
                logger?.debug(
                    "Sending action '\(label)' to '\(String(describing: type(of: self)))', depth: \(StoreContext.actionDepth)"
                )

                if let transaction {
                    withTransaction(transaction) {
                        apply(action)
                    }
                } else {
                    apply(action)
                }

                await intercept(action, transaction: transaction, signpostID: signpostID)
            }
        }

        let duration = Date().timeIntervalSince(start)

        if let signposter, let signpostIntervalState {
            signposter.endInterval(signpostIntervalName, signpostIntervalState)
        }

        logger?.info(
            "Action '\(label)' fully processed in \(duration, format: .fixed(precision: 3))s"
        )
    }

}

extension Store {

    func apply(_ action: Action) {
        let newState = reducer.reduce(state, with: action)
        guard newState != state else {
            return
        }

        let summary = Self.summaryOfChanges(between: self.state, and: newState)
        logger?.debug("State changed:\n\(summary)")
        state = newState
    }

    func intercept(_ action: Action, transaction: Transaction? = nil, signpostID: OSSignpostID?)
        async
    {
        await Task {
            for middleware in middlewares {
                let label = "\(String(describing: middleware.self))"
                if let signposter, let signpostID {
                    signposter.emitEvent("Middleware intercept", id: signpostID, "\(label)")
                }

                await intercept(action, using: middleware, transaction: transaction)

                if let signposter, let signpostID {
                    signposter.emitEvent("Middleware finished", id: signpostID, "\(label)")
                }

                guard !Task.isCancelled else { return }
            }
        }.value
    }

    private func intercept(
        _ action: Action,
        using middleware: some Middleware<State, Action>,
        transaction: Transaction? = nil
    ) async {
        guard let nextAction = await middleware.run(self.state, with: action) else {
            return
        }

        logger?.debug(
            "Middleware '\(String(describing: type(of: middleware)))' intercepted action: '\(String(describing: action))'"
        )

        guard !Task.isCancelled else { return }

        logger?.debug(
            "Middleware '\(String(describing: type(of: middleware)))' returned next action: '\(String(describing: nextAction))'"
        )

        if let transaction {
            await self.send(nextAction, transaction: transaction)
        } else {
            await self.send(nextAction)
        }
    }

}

enum StoreContext {
    @TaskLocal static var actionTraceID: UUID?
    @TaskLocal static var actionDepth: Int = 0
}
