//
//  FileManagerExtention.swift
//  FoundationExtension
//
//  Created by Kth on 12/13/24.
//

import Foundation

public extension FileManager {
    func save(_ data: Data, to url: URL) throws {
        let directory = url.deletingLastPathComponent()
        if !fileExists(atPath: directory.path) {
            try createDirectory(at: directory, withIntermediateDirectories: true)
        }

        try data.write(to: url)
    }
}
