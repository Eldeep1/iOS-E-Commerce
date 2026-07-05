//
//  OnboardingView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @EnvironmentObject var appState: AppStateManager
    
    @State private var currentStep = 0
    
    private let steps = [
        OnboardingStep(
            image: "onboarding1",
            title: "Discover Products",
            description: "Explore a catalog of premium items tailored to your lifestyle. From daily essentials to exclusive finds"
        ),
        OnboardingStep(
            image: "onboarding2",
            title: "Build Your Collection",
            description: "Save your favorites and unlock personalized recommendations based on what you love."
        ),
        OnboardingStep(
            image: "onboarding3",
            title: "Easy Payment",
            description: "Experience a seamless checkout process designed for your peace of mind. With multiple trusted payment options"
        )
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
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .ignoresSafeArea(edges: .top)
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.black
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray3
            }

            Button(action: {
                if currentStep < steps.count - 1 {
                    withAnimation {
                        currentStep += 1
                    }
                } else {
                    hasSeenOnboarding = true
                    withAnimation {
                        appState.currentRoute = .auth
                    }
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
                    .padding(.top, 16)
            }
            .padding(.bottom, 48)
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}
