//
//  OnboardingPageView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI
import UIKit

struct OnboardingPageView: View {
    let step: OnboardingStep
    
    var body: some View {
        GeometryReader { proxy in
            let imageHeight = (proxy.size.height * 0.65)

            VStack(spacing: 0) {
                Image(step.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: imageHeight)
                    .clipped()
                    .ignoresSafeArea(edges: .top)

                VStack(spacing: 36) {
                    Text(step.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 52)

                    Text(step.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Spacer()
                }
                .frame(width: proxy.size.width, height: proxy.size.height - imageHeight + 24)
                .background(Color.white)
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .offset(y: -20)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: -2)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    OnboardingPageView(step: OnboardingStep(image: "onboarding3", title: "Easy Payment", description: "Secure and fast checkout process."))
}
