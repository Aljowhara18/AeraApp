//
//  BurnexAppApp.swift
//  BurnexApp
//
//  Created by Jojo on 07/02/2026.
import SwiftUI

@main
struct AeraApp: App {
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @StateObject private var viewModel = TestViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if hasSeenOnboarding {
                    MainTabView()
                        .environmentObject(viewModel)
                } else {
                    OnboardingView()
                        .environmentObject(viewModel)
                }
            }
            .preferredColorScheme(.dark) 
        }
    }
}
