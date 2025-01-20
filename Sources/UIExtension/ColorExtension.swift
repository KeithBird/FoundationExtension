//
//  ColorExtension.swift
//
//
//  Created by Kth on 2024-02-04.
//

import Foundation
import SwiftUI

public extension Color {
    /// Create a color from a hex UInt
    ///
    /// e.g. 0x000000 -> black
    init(hex: UInt, opacity: Double = 1) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }

    /// Support opacity in two high digits
    ///
    /// e.g. 0xFFFFFF00 -> white with 0% opacity
    init(opacityHex hex: UInt) {
        let opacity = Double((hex >> 24) & 0xFF) / 255
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

#if canImport(UIKit)

import UIKit

public extension UIColor {
    static func mixing(_ color1: UIColor, with color2: UIColor) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        // add the components, but don't let them go above 1.0
        return UIColor(
            red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1),
            alpha: (a1 + a2) / 2
        )
    }

    static func multiply(_ color: UIColor, by multiplier: Double) -> UIColor {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
    }

    func getRGBA() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }

    /// Support opacity in two high digits
    ///
    /// e.g. 0xFFFFFF00 -> white with 0% opacity
    func hex(withOpacity: Bool) -> UInt {
        let (r, g, b, a) = getRGBA()
        if withOpacity {
            return UInt(a * 255) << 24 + UInt(r * 255) << 16 + UInt(g * 255) << 8 + UInt(b * 255)
        } else {
            return UInt(r * 255) << 16 + UInt(g * 255) << 8 + UInt(b * 255)
        }
    }
}

public extension Color {
    static func mixing(_ color1: Color, with color2: Color) -> Color {
        Color(UIColor.mixing(.init(color1), with: .init(color2)))
    }

    static func multiply(_ color: Color, by multiplier: Double) -> Color {
        Color(UIColor.multiply(UIColor(color), by: multiplier))
    }
}

@dynamicMemberLookup
public struct CodableColor: Sendable, Equatable {
    public init(uiColor color: UIColor) {
        self.uiColor = color
    }

    public init(_ color: Color) {
        self.init(uiColor: .init(color))
    }

    public var uiColor: UIColor

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<UIColor, T>) -> T {
        get { uiColor[keyPath: keyPath] }
        set { uiColor[keyPath: keyPath] = newValue }
    }
}

public extension CodableColor {
    var swiftUI: Color { .init(uiColor: uiColor) }
}

extension CodableColor: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid color"
            )
        }
        self.init(uiColor: color)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(
            withRootObject: uiColor,
            requiringSecureCoding: true
        )
        try container.encode(data)
    }
}

#endif
