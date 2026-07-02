//
//  EventCard.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 02/07/2026.
//

import SwiftUI

struct EventCard: View {
    var event : Event
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(event.img)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 210)
                .overlay(Color.black.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 40) {
                
            VStack(alignment: .leading, spacing: 10) {
                Text(event.title)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.8)
                
                Text(event.subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
                
                Button(action: {

                }) {
                    Text(event.btnText)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
        }
        .frame(height: 210)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    EventCard(event: Event(
title: "Unleash Next-Gen",
subtitle: "High-energy commercial photography highlighting futuristic mobile innovation.",
img: "neon_smartphone",
btnText: "Pre-Order"
))
}
