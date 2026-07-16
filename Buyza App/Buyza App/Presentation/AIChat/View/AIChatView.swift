//
//  AIChatView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 06/07/2026.
//

import SwiftUI

struct AIChatView: View {
    @StateObject private var viewModel = AIChatViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // Chat History
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.isUser { Spacer() }
                            
                            Text(message.text)
                                .padding()
                                .background(message.isUser ? Color.black : Color(.systemGray5))
                                .foregroundColor(message.isUser ? .white : .black)
                                .cornerRadius(16)
                            
                            if !message.isUser { Spacer() }
                        }
                        .padding(.horizontal)
                    }
                    
                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            
            HStack {
                TextField("Ask about products...", text: $viewModel.currentInput)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(24)
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.black)
                        .clipShape(Circle())
                }
                .disabled(viewModel.currentInput.isEmpty || viewModel.isLoading)
            }
            .padding()
        }
        .navigationTitle("Buyza AI")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    AIChatView()
}
