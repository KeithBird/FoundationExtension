//
//  File.swift
//  FoundationExtension
//
//  Created by Kth on 1/20/25.
//

import Foundation

public extension Locale {
    static var preferChinese: Bool {
        Locale.preferredLanguages.first?.contains("zh") ?? false
    }
}
