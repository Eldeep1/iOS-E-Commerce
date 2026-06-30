//
//  ProductImageCarousel.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import SwiftUI

struct ProductImageCarousel: View {
    let imageURLs: [URL]
    @Binding var currentIndex: Int
    let isFavorite: Bool
    let onFavoriteTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(Array(imageURLs.enumerated()), id: \.offset) { index, url in
                    carouselImage(url: url)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 360)

            pageIndicator
                .padding(.bottom, 24)
        }
        .overlay(alignment: .topTrailing) {
            carouselActionButton(
                systemName: isFavorite ? "heart.fill" : "heart",
                action: onFavoriteTap
            )
            .padding(.top, 16)
            .padding(.trailing, 20)
        }
    }

    private func carouselImage(url: URL) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.85, green: 0.78, blue: 0.95),
                    Color(red: 0.75, green: 0.88, blue: 0.98),
                    Color(red: 0.98, green: 0.85, blue: 0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(48)
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.8))
                default:
                    ProgressView()
                        .tint(.white)
                }
            }
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(imageURLs.indices, id: \.self) { index in
                Capsule()
                    .fill(Color.white.opacity(index == currentIndex ? 1 : 0.45))
                    .frame(width: index == currentIndex ? 24 : 8, height: 8)
            }
        }
    }

    private func carouselActionButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.black.opacity(0.25))
                .clipShape(Circle())
        }
    }
}
