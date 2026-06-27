//
//  OnboardingPageView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI

struct OnboardingPageView: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(step.image)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .foregroundColor(.blue)
            
            Text(step.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(step.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingPageView(step: OnboardingStep(image: "onboarding3", title: "Easy Payment", description: "Secure and fast checkout process."))
}
