//
//  ChatMessage.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 06/07/2026.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
