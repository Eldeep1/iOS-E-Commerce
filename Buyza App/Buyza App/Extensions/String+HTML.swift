//
//  String+HTML.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

extension String {
    var htmlStripped: String {
        guard contains("<"), contains(">") else {
            return trimmingCharacters(in: .whitespacesAndNewlines)
        }

        var result = self
        let entities = [
            "&nbsp;": " ",
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&#39;": "'"
        ]

        for (entity, value) in entities {
            result = result.replacingOccurrences(of: entity, with: value)
        }

        return result
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
