//
//  CounterReducerTests.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation
import Testing

@testable import ReduxExample

@Suite("CounterReducer")
struct CounterReducerTests {

    @Suite("setCount")
    struct SetCountTests {

        let reducer: CounterReducer

        init() {
            self.reducer = CounterReducer()
        }

        @Test(
            "Given state count is zero when reduced with setCount action then state count is updated"
        )
        func givenStateCountIsZeroWhenReducedWithSetCountActionThenStateCountIsUpdated() {
            let state = CounterState(count: 0)
            let count = 10

            let newState = reducer.reduce(state, with: .setCount(count))

            #expect(newState.count == count)
        }

        @Test(
            "Given state count is one and canDecrement is true when reduced with setCount(0) action then state canDecrement is false"
        )
        func
            givenStateCountIsOneAndCanDecrementIsTrueWhenReducedWithSetCountZeroActionThenStateCanDecrementIsFalse()
        {
            let state = CounterState(count: 1, canDecrement: true)

            let newState = reducer.reduce(state, with: .setCount(0))

            #expect(!newState.canDecrement)
        }

        @Test(
            "Given state count is zero and canDecrement is false when reduced with setCount(1) action then state canDecrement is true"
        )
        func
            givenStateCountIsZeroAndCanDecrementIsFalseWhenReducedWithSetCountOneActionThenStateCanDecrementIsTrue()
        {
            let state = CounterState(count: 1, canDecrement: false)

            let newState = reducer.reduce(state, with: .setCount(1))

            #expect(newState.canDecrement)
        }

    }

    @Suite("setNumberFact")
    struct SetNumberFactTests {

        let reducer: CounterReducer

        init() {
            self.reducer = CounterReducer()
        }

        @Test(
            "Given state fact is nil when reduced with setNumberFact action then state fact is set")
        func givenStateFactIsNilWhenReducedWithSetNumberFactThenStateFactIsSet() {
            let state = CounterState(fact: nil)
            let fact = "Random fact"

            let newState = reducer.reduce(state, with: .setNumberFact(fact))

            #expect(newState.fact == fact)
        }

    }

    @Suite("setAlertPresented")
    struct SetAlertPresented {

        let reducer: CounterReducer

        init() {
            self.reducer = CounterReducer()
        }

        @Test(
            "Given state setAlertPresented is false when reduced with setAlertPresented(true) action then state setAlertPresented is true"
        )
        func
            givenStateSetAlertPresentedIsFalseWhenReducedWithSetAlertPresentedTrueThenStateSetAlertPresentedIsTrue()
        {
            let state = CounterState(isAlertPresented: false)

            let newState = reducer.reduce(state, with: .setAlertPresented(true))

            #expect(newState.isAlertPresented)
        }

        @Test(
            "Given state setAlertPresented is true when reduced with setAlertPresented(false) action then state setAlertPresented is false"
        )
        func
            givenStateSetAlertPresentedIsTrueWhenReducedWithSetAlertPresentedFalseThenStateSetAlertPresentedIsFalse()
        {
            let state = CounterState(isAlertPresented: true)

            let newState = reducer.reduce(state, with: .setAlertPresented(false))

            #expect(!newState.isAlertPresented)
        }

    }

}
