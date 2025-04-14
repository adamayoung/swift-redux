//
//  CounterMiddlewareTests.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import Foundation
import Testing

@testable import ReduxExample

@Suite("CounterMiddleware")
struct CounterMiddlewareTests {

    @Suite("increment")
    struct IncrementTests {

        let middleware: CounterMiddleware
        let counterService: CounterStubService

        init() {
            self.counterService = CounterStubService()
            self.middleware = CounterMiddleware(counterService: counterService)
        }

        @Test(
            "Given state count is zero when run with increment action then returns setCount(1) action"
        )
        func givenStateCountIsZeroWhenRunWithIncrementActionThenReturnsSetCount1Action() async {
            let state = CounterState(count: 0)

            let nextAction = await middleware.run(state, with: .increment)

            #expect(nextAction == .setCount(1))
        }

    }

    @Suite("decrement")
    struct DecrementTests {

        let middleware: CounterMiddleware
        let counterService: CounterStubService

        init() {
            self.counterService = CounterStubService()
            self.middleware = CounterMiddleware(counterService: counterService)
        }

        @Test("Given state count is zero when run with decrement action then returns nil")
        func givenStateCountIsZeroWhenRunWithDecrementActionThenReturnsNil() async {
            let state = CounterState(count: 0)

            let nextAction = await middleware.run(state, with: .decrement)

            #expect(nextAction == nil)
        }

        @Test(
            "Given state count is one when run with decrement action then returns setCount(0) action"
        )
        func givenStateCountIsOneWhenRunWithDecrementActionThenReturnsSetCountZeroAction() async {
            let state = CounterState(count: 1)

            let nextAction = await middleware.run(state, with: .decrement)

            #expect(nextAction == .setCount(0))
        }

    }

    @Suite("random")
    struct RandomTests {

        let middleware: CounterMiddleware
        let counterService: CounterStubService

        init() {
            self.counterService = CounterStubService()
            self.middleware = CounterMiddleware(counterService: counterService)
        }

        @Test("Given state when run with random action then returns setCount(randomNumber) action")
        func givenStateWhenRunWithRandomActionThenReturnsSetCountRandomNumberAction() async {
            let state = CounterState()
            counterService.generateRandomNumberResult = 9

            let nextAction = await middleware.run(state, with: .random)

            #expect(nextAction == .setCount(9))
            #expect(counterService.generateRandomNumberCalls == 1)
        }

    }

    @Suite("setCount")
    struct SetCountTests {

        let middleware: CounterMiddleware
        let counterService: CounterStubService

        init() {
            self.counterService = CounterStubService()
            self.middleware = CounterMiddleware(counterService: counterService)
        }

        @Test("Given state when run with setCount action then returns fetchNumberFact action")
        func givenStateWhenRunWithSetCountActionThenReturnsFetchNumberFactAction() async {
            let state = CounterState()

            let nextAction = await middleware.run(state, with: .setCount(0))

            #expect(nextAction == .fetchNumberFact)
        }

    }

    @Suite("fetchNumberFact")
    struct FetchNumberFactTests {

        let middleware: CounterMiddleware
        let counterService: CounterStubService

        init() {
            self.counterService = CounterStubService()
            self.middleware = CounterMiddleware(counterService: counterService)
        }

        @Test(
            "Given state count is 2 when run with fetchNumberFact action then returns setNumberFact action"
        )
        func givenStateCountIs2WhenRunWithFetchNumberFactActionThenReturnsSetNumberFactAction()
            async
        {
            let state = CounterState(count: 2)
            counterService.numberFactResult = "Test fact"

            let nextAction = await middleware.run(state, with: .fetchNumberFact)

            #expect(nextAction == .setNumberFact("Test fact"))
            #expect(counterService.numberFactCalls == 1)
            #expect(counterService.lastNumberFactNumber == 2)
        }

    }

}
