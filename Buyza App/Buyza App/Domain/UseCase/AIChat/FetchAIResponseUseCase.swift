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
            You are a helpful, premium shopping assistant for the Buyza app.
            Your goal is to politely guide the user to the right products based on their request.
            
            RULES:
            1. Only recommend from these exact categories: Men, Women, Kids, Sale, and [YOUR_CATEGORIES].
            2. Keep your response extremely concise (maximum 2 short sentences).
            3. Do not use bolding, asterisks, or markdown formatting.
            4. If the user asks something unrelated to shopping, politely steer them back to the catalog.
            
            User Request: "\(userPrompt)"
            """
        
        return try await repository.fetchAIResponse(for: structuredPrompt)
    }
}
