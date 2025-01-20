//
//  SwiftUIExtension.swift
//  WatchPark
//
//  Created by Keith on 7/25/24.
//

import SwiftUI

#if os(iOS)
public enum Screen {
    @MainActor public static var size: CGSize { UIScreen.main.bounds.size }
    @MainActor public static var scale: CGFloat { UIScreen.main.bounds.size.width / 393 }
    @MainActor public static var safeAreaInsets: EdgeInsets? { UIApplication.shared.currentWindow?.safeAreaInsets.swiftUIInsets }
}

public extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

#elseif os(watchOS)

public enum Screen {
    public static let scale = size.width / 198
    public static let defaultAspectRatio = 198.0 / 242
    public static let aspectRatio = size.width / size.height
    public static let size = WKInterfaceDevice.current().screenBounds.size
}

public extension CGSize {
    static let defaultSize = CGSize(width: 198, height: 242)
}

#endif

#if canImport(UIKit)

private extension UIEdgeInsets {
    var swiftUIInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

#endif
