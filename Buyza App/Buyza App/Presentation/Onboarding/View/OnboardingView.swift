//
//  OnboardingView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    
    @State private var currentStep = 0
    
    private let steps = [
        OnboardingStep(image: "onboarding1", title: "Discover Products You'll Love", description: "Find everything you need in one place."),
        OnboardingStep(image: "onboarding2", title: "Build Your Personal Collection", description: "Save your favorites and unlock personalized recommendations based on what you love."),
        OnboardingStep(image: "onboarding3", title: "Easy Payment", description: "Secure and fast checkout process.")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentStep) {
                ForEach(0..<steps.count, id: \.self) { index in
                    OnboardingPageView(step: steps[index])
                        .tag(index)
                }
            }

            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Button(action: {
                if currentStep < steps.count - 1 {
                    withAnimation {
                        currentStep += 1
                    }
                } else {
                    hasSeenOnboarding = true
                }
            }) {
                Text(currentStep < steps.count - 1 ? "Next" : "Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}
