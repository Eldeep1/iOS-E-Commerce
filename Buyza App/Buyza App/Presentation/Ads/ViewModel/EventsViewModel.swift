//
//  EventsViewModel.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 02/07/2026.
//

import Foundation

class EventsViewModel {
    let events: [Event] = [
        Event(
            title: "Timeless Luxury",
            subtitle: "Elevate your style with premium timepieces crafted for everyday elegance.",
            img: "lifestyle_watch",
            btnText: "Explore Now"
        ),
        Event(
            title: "Unleash Next-Gen",
            subtitle: "Experience the incredible power and speed of futuristic 5G innovation.",
            img: "neon_smartphone",
            btnText: "Pre-Order"
        ),
        Event(
            title: "Immersive Audio",
            subtitle: "Water-resistant, premium sound engineered to fuel your active lifestyle.",
            img: "waterproof_headphones",
            btnText: "Shop Gear"
        ),
        Event(
            title: "Pure Sophistication",
            subtitle: "Discover your new signature scent with elite, earthy fragrance notes.",
            img: "luxury_perfume",
            btnText: "Discover Scent"
        )
    ]
}
