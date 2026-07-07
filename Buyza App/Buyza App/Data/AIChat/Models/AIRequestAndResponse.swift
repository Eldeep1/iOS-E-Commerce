//
//  AIRequestAndResponse.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 06/07/2026.
//

import Foundation

struct GeminiRequest: Codable {
    let contents: [GeminiContent]
}

struct GeminiResponse: Codable {
    let candidates: [GeminiCandidate]?
}

struct GeminiCandidate: Codable {
    let content: GeminiContent?
}

struct GeminiContent: Codable {
    let parts: [GeminiPart]
}

struct GeminiPart: Codable {
    let text: String
}
