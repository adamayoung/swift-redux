# Swift Redux

Redux implemented in Swift using Swift Concurrency and Combine.

## Example usage

```swift
struct CounterState: Equatable, Sendable {
    var count: Int
    var isAlertPresented: Bool

    init(
        count: Int = 0,
        isAlertPresented: Bool = false
    ) {
        self.count = count
        self.isAlertPresented = isAlertPresented
    }
}

enum CounterAction: Sendable {
    case increment
    case decrement
    case fetchCounter
    case setCount(Int)
}

struct CounterReducer: Reducer {
    func reduce(_ oldState: CounterState, with action: CounterAction) -> CounterState {
        var state = oldState

        switch action {
        case .increment: state.count += 1
        case .decrement: state.count -= 1
        case .setCount(let count): state.count = count
        case .setAlertPresented(let isPresented): state.isAlertPresented = isPresented
        default: break
        }

        return state
    }
}

actor CounterMiddleware: Middleware {
    func run(_ state: CounterState, with action: CounterAction) async -> CounterAction? {
        switch action {
        case .random:
            try? await Task.sleep(for: .milliseconds(Int.random(in: 0...500)))
            guard !Task.isCancelled else {
                return nil
            }

            let count = Int.random(in: 0...500)
            return .setCount(count)

        default:
            return nil
        }
    }
}

typealias CounterStore = Store<CounterState, CounterAction>

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

    private func increment() {
        Task {
            await store.send(.increment)
        }
    }

    private func decrement() {
        Task {
            await store.send(.decrement)
        }
    }

    private func random() {
        Task {
            await store.send(.setAlertPresented(true))
            await store.send(.random)
        }
    }
}
```

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add the SwiftRedux package as a dependency to your `Package.swift` file, and add it
as a dependency to your target.

```swift
// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "MyProject",
    dependencies: [
        .package(url: "https://github.com/adamayoung/swift-redux.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MyProject",
            dependencies: [.product(name: "SwiftRedux", package: "swift-redux")]
        )
    ]
)
```

### Xcode project

Add the SwiftRedux package to your Project's Package dependencies.
