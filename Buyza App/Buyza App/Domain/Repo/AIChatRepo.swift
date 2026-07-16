//
//  AIChatRepo.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 06/07/2026.
//

import Foundation

protocol AIChatRepositoryProtocol {
    func fetchAIResponse(for prompt: String) async throws -> String
}
