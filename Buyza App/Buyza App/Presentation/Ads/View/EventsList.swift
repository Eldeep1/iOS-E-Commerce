//
//  EventsList.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 02/07/2026.
//

import SwiftUI

struct EventsList: View {
    @EnvironmentObject private var localization: LocalizationManager
    @State private var currentIndex = 0

    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    private var events: [Event] {
        [
            Event(
                title: localization.text(.event1Title),
                subtitle: localization.text(.event1Subtitle),
                img: "lifestyle_watch",
                btnText: localization.text(.event1Button)
            ),
            Event(
                title: localization.text(.event2Title),
                subtitle: localization.text(.event2Subtitle),
                img: "mobile",
                btnText: localization.text(.event2Button)
            ),
            Event(
                title: localization.text(.event3Title),
                subtitle: localization.text(.event3Subtitle),
                img: "waterproof_headphones",
                btnText: localization.text(.event3Button)
            ),
            Event(
                title: localization.text(.event4Title),
                subtitle: localization.text(.event4Subtitle),
                img: "luxury_perfume",
                btnText: localization.text(.event4Button)
            )
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentIndex) {
                ForEach(0..<events.count, id: \.self) { index in
                    EventCard(event: events[index])
                        .padding(.horizontal, 24)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 210)

            HStack(spacing: 8) {
                ForEach(0..<events.count, id: \.self) { index in
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
                if currentIndex < events.count - 1 {
                    currentIndex += 1
                } else {
                    currentIndex = 0
                }
            }
        }
        .onChange(of: localization.currentLanguage) { _ in
            currentIndex = 0
        }
    }
}

#Preview {
    EventsList()
        .environmentObject(LocalizationManager())
}
