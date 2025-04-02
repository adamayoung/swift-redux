//
//  Reducer.swift
//  SwiftRedux
//
//  Created by Adam Young on 02/04/2025.
//

///
/// A protocol to mutate state depending on an action.
///
public protocol Reducer<State, Action>: Sendable {

    ///
    /// The associated state.
    ///
    associatedtype State

    ///
    /// The associated action.
    ///
    associatedtype Action

    ///
    /// Processes an action by mutating state to a new state.
    ///
    /// - Parameters:
    ///   - oldState: The state to process.
    ///   - action: The action to process.
    ///
    /// - Returns: The state after mutation.
    ///
    func reduce(_ oldState: State, with action: Action) -> State

}
