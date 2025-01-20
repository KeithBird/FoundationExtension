//
//  FormatExtension.swift
//
//
//  Created by Kth on 2024-06-24.
//

import Foundation

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Double {
    func roundedStr() -> String {
        rounded().formatted()
    }

    /// - Parameters:
    ///  - unit: The increment to round to. e.g. 10, 0.1, -0.001
    func roundedStr(unit: Double) -> String {
        formatted(.number.rounded(rule: .toNearestOrAwayFromZero, increment: unit))
    }

    /// - Parameters:
    /// - length: The number of digits after the decimal point.
    ///
    /// ```swift
    /// 1.2345.roundedStr(fraction: 3) // 1.235
    /// ```
    func roundedStr(fraction length: Int) -> String {
        let increment = Double(truncating: pow(0.1, length) as NSNumber)
        return formatted(.number
            .rounded(rule: .toNearestOrAwayFromZero, increment: increment)
            .precision(.fractionLength(length))
        )
    }
}
