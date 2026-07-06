//
//  AIChatViewModel.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 06/07/2026.
//

import Foundation

@MainActor
class AIChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var currentInput: String = ""
    @Published var isLoading: Bool = false
    
    private let fetchAIResponseUseCase: FetchAIResponseUseCaseProtocol
    
    init(fetchAIResponseUseCase: FetchAIResponseUseCaseProtocol = FetchAIResponseUseCase()) {
        self.fetchAIResponseUseCase = fetchAIResponseUseCase
        
        messages.append(ChatMessage(text: "Hi! I'm your Buyza shopping assistant. What are you looking for today ?", isUser: false))
    }
    
    func sendMessage() {
        let userText = currentInput.trimmingCharacters(in: .whitespaces)
        guard !userText.isEmpty else { return }
        
        messages.append(ChatMessage(text: userText, isUser: true))
        currentInput = ""
        isLoading = true
        
        Task {
            do {
                let aiResponse = try await fetchAIResponseUseCase.execute(with: userText)
                
                messages.append(ChatMessage(text: aiResponse, isUser: false))
            } catch {
                print("AIChat Error: \(error)")
                messages.append(ChatMessage(text: "Oops! \(error.localizedDescription)", isUser: false))
            }
            isLoading = false
        }
    }
}
