//
//  JSONFormat.swift
//  Milvus
//
//  Created by Kth on 1/2/25.
//

import Foundation

public extension Data {
    func toPrettyJSON() throws -> String? {
        let object = try JSONSerialization.jsonObject(with: self)
        let data = try JSONSerialization.data(
            withJSONObject: object,
            options: [.prettyPrinted, .sortedKeys]
        )
        return String(data: data, encoding: .utf8)
    }
}

public extension Encodable {
    func toPrettyJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(self) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
