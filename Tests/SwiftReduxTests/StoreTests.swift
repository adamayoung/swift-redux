//
//  StoreTests.swift
//  SwiftRedux
//
//  Created by Adam Young on 02/04/2025.
//

import Testing

@testable import SwiftRedux

@Suite
@MainActor
struct StoreTests {

    let store: CounterStore

    init() {
        self.store = CounterStore(
            initialState: .init(),
            reducer: CounterReducer(),
            middlewares: [GenerateCounterMiddleware()]
        )
    }

    @Test
    func testIncrement() async {
        await store.send(.increment)

        #expect(store.count == 1)
    }

    @Test
    func testDecrement() async {
        await store.send(.decrement)

        #expect(store.count == -1)
    }

    @Test
    func testGenerate() async {
        await store.send(.fetchCounter)

        #expect(store.count == 1000)
    }

    @Test
    func testBinding() async {
        let binding = store.binding(
            extract: \.count,
            embed: CounterAction.setCount
        )
        binding.wrappedValue = 10

        #expect(store.count == 10)
    }

}
