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
    @EnvironmentObject private var localization: LocalizationManager
    
    @State private var currentStep = 0
    
    private var steps: [OnboardingStep] {
        [
            OnboardingStep(
                image: "onboarding1",
                title: localization.text(.onboarding1Title),
                description: localization.text(.onboarding1Description)
            ),
            OnboardingStep(
                image: "onboarding2",
                title: localization.text(.onboarding2Title),
                description: localization.text(.onboarding2Description)
            ),
            OnboardingStep(
                image: "onboarding3",
                title: localization.text(.onboarding3Title),
                description: localization.text(.onboarding3Description)
            )
        ]
    }
    
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
                Text(currentStep < steps.count - 1 ? localization.text(.next) : localization.text(.getStarted))
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
        .environmentObject(AppStateManager())
        .environmentObject(LocalizationManager())
}
