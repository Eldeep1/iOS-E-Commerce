//
//  AIChatRemoteDataSource.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 06/07/2026.
//

import Foundation

import Foundation

protocol AIChatRemoteDataSourceProtocol {
    func fetchGeminiResponse(for prompt: String) async throws -> GeminiResponse
}

class AIChatRemoteDataSource: AIChatRemoteDataSourceProtocol {
    private let apiKey = "AQ.Ab8RN6Lya5WAYIl5Pvm7AnB3IR4LoBZSLWJ3vE1LuIO89DsOPw"
    private let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
    
    func fetchGeminiResponse(for prompt: String) async throws -> GeminiResponse {
        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        let requestBody = GeminiRequest(contents: [
            GeminiContent(parts: [GeminiPart(text: prompt)])
        ])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "X-goog-api-key")
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorString = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Gemini API Error (\((response as? HTTPURLResponse)?.statusCode ?? 0)): \(errorString)")
            throw NSError(domain: "GeminiAPIError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Server returned \((response as? HTTPURLResponse)?.statusCode ?? 500). Please check your API key."])
        }
        
        return try JSONDecoder().decode(GeminiResponse.self, from: data)
    }
}
