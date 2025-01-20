//
//  LogExtension.swift
//  Shared
//
//  Created by Kth on 1/14/25.
//

import Logging

public extension Logger {
    @inlinable
    func error(
        _ error: Error,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        self.error("\n\(error)\n", metadata: metadata(), source: nil, file: file, function: function, line: line)
    }

    @inlinable
    func message(
        _ message: String,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        info("\n\(message)\n", metadata: metadata(), source: nil, file: file, function: function, line: line)
    }
}
