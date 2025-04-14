//
//  CounterView.swift
//  ReduxExample
//
//  Created by Adam Young on 14/04/2025.
//

import SwiftUI

struct CounterView: View {

    @State private var store = CounterStore(
        initialState: .init(),
        reducer: CounterReducer(),
        middlewares: [CounterMiddleware()]
    )
    private var isAlertPresented: Binding<Bool> {
        store.binding(extract: \.isAlertPresented , embed: CounterAction.setAlertPresented)
    }

    var body: some View {
        VStack {
            Spacer()

            Text("\(store.count)")
                .font(.title)

            Spacer()

            Text("Alert presented: \(store.isAlertPresented)")

            HStack(spacing: 30) {
                Button(action: decrement) {
                    Image(systemName: "minus")
                        .frame(height: 30)
                }
                .buttonStyle(.borderedProminent)

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
            .alert("Generating random number", isPresented: isAlertPresented) {
                Button("OK", action: {})
            }
        }
        .padding()
    }

    func increment() {
        Task {
            await store.send(.increment, animation: .easeIn)
        }
    }

    func decrement() {
        Task {
            await store.send(.decrement)
        }
    }

    func random() {
        Task {
            await store.send(.setAlertPresented(true))
            await store.send(.random)
        }
    }

}

#Preview {
    CounterView()
}
