//
//  Middleware.swift
//  SwiftRedux
//
//  Created by Adam Young on 02/04/2025.
//

import Foundation

///
/// A protocol to intercept an action to return another one.
///
/// Usually used to perform an a task other than changing state.
///
public protocol Middleware<State, Action>: Sendable {

    ///
    /// The associated state.
    ///
    associatedtype State: Sendable

    ///
    /// The associated action.
    ///
    associatedtype Action: Sendable

    ///
    /// Processes an action and optionally returns another one.
    ///
    /// - Parameters:
    ///   - state: The current state.
    ///   - action: The action being processed.
    ///
    /// - Returns: An optional action to perform after processing.
    ///
    func run(_ state: State, with action: Action) async -> Action?

}
