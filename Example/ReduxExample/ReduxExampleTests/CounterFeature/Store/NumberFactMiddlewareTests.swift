//
//  NumberFactMiddlewareTests.swift
//  ReduxExample
//
//  Created by Adam Young on 15/04/2025.
//

import Foundation
import Testing

@testable import ReduxExample

@Suite("NumberFactMiddleware")
struct NumberFactMiddlewareTests {

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
