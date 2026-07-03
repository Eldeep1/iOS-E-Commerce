//
//  EventsList.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 02/07/2026.
//

import SwiftUI

struct EventsList: View {
    var viewModel: EventsViewModel = EventsViewModel()
    @State private var currentIndex = 0
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentIndex) {
                ForEach(0..<viewModel.events.count, id: \.self) { index in
                    EventCard(event: viewModel.events[index])
                        .padding(.horizontal, 24)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 210)
            
            HStack(spacing: 8) {
                ForEach(0..<viewModel.events.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color.black : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentIndex == index ? 1.2 : 1.0)
                }
            }
            .padding(.top, 24)
            
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                if currentIndex < viewModel.events.count - 1 {
                    currentIndex += 1
                } else {
                    currentIndex = 0 
                }
            }
        }
    }
}

#Preview {
    EventsList(viewModel: EventsViewModel())
}
