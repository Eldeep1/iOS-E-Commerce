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
                .frame(width: 380, height: 210)
                .overlay(Color.black.opacity(0.4))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.8)
                
                Text(event.subtitle)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
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
            .padding(.horizontal, 24)
            .padding(.top, 40)
            .padding(.bottom, 24)
        }
        .frame(width: 380, height: 210)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
    }
}

//#Preview {
//    EventCard()
//}
