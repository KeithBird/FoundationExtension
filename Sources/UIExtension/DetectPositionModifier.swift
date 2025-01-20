//
//  DetectPositionModifier.swift
//
//
//  Created by Kth on 2024-02-07.
//

import SwiftUI

public struct ScrollOffsetPreferenceKey: PreferenceKey {
    public static let defaultValue: CGPoint = .zero
    public static func reduce(value _: inout CGPoint, nextValue _: () -> CGPoint) {}
}

private struct DetectPositionModifier: ViewModifier {
    let space: CoordinateSpace
    @Binding var scrollPosition: CGPoint

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(in: space).origin
                        )
                }
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollPosition = value
            }
    }
}

public extension View {
    @ViewBuilder func detectPosition(
        _ position: Binding<CGPoint>,
        enable: Bool = true,
        in coordinateSpace: CoordinateSpace = .global
    ) -> some View {
        if enable {
            modifier(DetectPositionModifier(space: coordinateSpace, scrollPosition: position))
        } else {
            self
        }
    }
}
