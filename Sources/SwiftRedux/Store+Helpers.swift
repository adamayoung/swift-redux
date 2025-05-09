//
//  Store+Helpers.swift
//  SwiftRedux
//
//  Created by Adam Young on 25/04/2025.
//

import Foundation

extension Store {

    static func summaryOfChanges(between oldState: State, and newState: State) -> String {
        let oldStateMirror = Mirror(reflecting: oldState)
        let newStateMirror = Mirror(reflecting: newState)

        var changes: [(label: String, oldValue: String, newValue: String, changeType: String)] = []

        func sanitize(_ value: Any) -> String {
            var valueAsString = String(describing: value)
            if valueAsString.hasPrefix("Optional(") {
                valueAsString = String(valueAsString.dropFirst("Optional(".count).dropLast(1))
            }
            return valueAsString
        }

        for (oldChild, newChild) in zip(oldStateMirror.children, newStateMirror.children) {
            let label = sanitize(oldChild.label ?? "")
            let oldValue = sanitize(oldChild.value)
            let newValue = sanitize(newChild.value)

            if oldValue != newValue {
                let changeType = {
                    if oldValue.isEmpty {
                        return "Added"
                    }

                    if newValue.isEmpty {
                        return "Removed"
                    }

                    return "Updated"
                }()
                changes.append((label, oldValue, newValue, changeType))
            }
        }

        let summary = changes.map {
            "\($0.label) (\($0.changeType))\n\t- \($0.oldValue)\n\t+ \($0.newValue)"
        }.joined(separator: "\n")

        return summary
    }

}
