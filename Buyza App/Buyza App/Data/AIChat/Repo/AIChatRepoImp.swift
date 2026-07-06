//
//  AIChatRepoImp.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 06/07/2026.
//

import Foundation

class AIChatRepository: AIChatRepositoryProtocol {
    private let dataSource: AIChatRemoteDataSourceProtocol
    
    init(dataSource: AIChatRemoteDataSourceProtocol = AIChatRemoteDataSource()) {
        self.dataSource = dataSource
    }
    
    func fetchAIResponse(for prompt: String) async throws -> String {
        do {
            let geminiResponse = try await dataSource.fetchGeminiResponse(for: prompt)
            
            if let text = geminiResponse.candidates?.first?.content?.parts.first?.text {
                return text
            } else {
                return "Sorry, I couldn't understand that."
            }
        } catch {
            throw error
        }
    }
}
