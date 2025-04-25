//
//  CounterView.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import SwiftUI
import os

struct CounterView: View {

    @State private var store: CounterStore

    init() {
        self.init(
            store: CounterStore(
                initialState: .init(),
                reducer: CounterReducer(),
                middlewares: [
                    CounterMiddleware(
                        counterService: ExampleCounterService()
                    ),
                    NumberFactMiddleware(
                        counterService: ExampleCounterService()
                    )
                ],
                logger: Logger(subsystem: "uk.co.adam-young.ReduxExample", category: "CounterStore")
            )
        )
    }

    init(store: CounterStore) {
        self._store = .init(wrappedValue: store)
    }

    private var canDecrement: Bool {
        store.canDecrement
    }

    private var isAlertPresented: Binding<Bool> {
        store.binding(extract: \.isAlertPresented, embed: CounterAction.setAlertPresented)
    }

    var body: some View {
        VStack {
            Spacer()

            Text(verbatim: "\(store.count)")
                .font(.system(size: 50, weight: .bold))

            Text(verbatim: "\(store.fact ?? "")")
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding()
                .frame(height: 100)
                .frame(maxWidth: 500)

            Spacer()

            Text(verbatim: "Alert presented: \(store.isAlertPresented)")

            controlsView()
        }
        .padding()
        .alert("Generating random number", isPresented: isAlertPresented) {
            Button("OK", action: {})
        }
        .task {
            await store.send(.fetchNumberFact)
        }
    }

}

extension CounterView {

    @ViewBuilder
    private func controlsView() -> some View {
        HStack(spacing: 30) {
            Button(action: decrement) {
                Image(systemName: "minus")
                    .frame(height: 30)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!canDecrement)

            Button(action: random) {
                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                    .frame(height: 30)
            }
            .buttonStyle(.borderedProminent)

            Button(action: increment) {
                Image(systemName: "plus")
                    .frame(height: 30)
            }
            .buttonStyle(.borderedProminent)
        }
    }

}

extension CounterView {

    private func increment() {
        Task {
            await store.send(.increment, animation: .easeInOut)
        }
    }

    private func decrement() {
        Task {
            await store.send(.decrement, animation: .easeInOut)
        }
    }

    private func random() {
        Task {
            await store.send(.setAlertPresented(true))
            await store.send(.random)
        }
    }

}

#Preview {
    CounterView()
}
