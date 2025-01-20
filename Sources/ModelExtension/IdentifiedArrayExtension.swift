//
//  IdentifiedArrayExtension.swift
//
//
//  Created by Kth on 2024-05-14.
//

import Foundation
import IdentifiedCollections

@dynamicMemberLookup
public struct Unique<Value: Codable & Sendable>: Identifiable, Codable, Equatable, Sendable {
    public static func == (lhs: Unique<Value>, rhs: Unique<Value>) -> Bool {
        lhs.id == rhs.id
    }

    public init(_ value: Value) {
        self.id = .init()
        self.value = value
    }

    public let id: UUID
    public let value: Value

    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
}

public extension IdentifiedArray where Element: Identifiable, ID == UUID {
    init<T>(_ elements: some Sequence<T>) where Element == Unique<T> {
        self.init(IdentifiedArray(uniqueElements: elements.map { Unique($0) }))
    }
}
