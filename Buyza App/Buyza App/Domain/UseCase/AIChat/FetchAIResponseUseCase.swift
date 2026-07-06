//
//  FetchAIResponseUseCase.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 06/07/2026.
//

import Foundation

protocol FetchAIResponseUseCaseProtocol {
    func execute(with userPrompt: String) async throws -> String
}

class FetchAIResponseUseCase: FetchAIResponseUseCaseProtocol {
    private let repository: AIChatRepositoryProtocol
    
    init(repository: AIChatRepositoryProtocol = AIChatRepository()) {
        self.repository = repository
    }
    
    func execute(with userPrompt: String) async throws -> String {
        let structuredPrompt = """
        You are a helpful, concise shopping assistant for an e-commerce app called Buyza.
        Recommend specific product types or categories (for your information the
        categories we have are men, women, hydrogen, kids and sale) based on this request: \(userPrompt)
        """
        
        return try await repository.fetchAIResponse(for: structuredPrompt)
    }
}
