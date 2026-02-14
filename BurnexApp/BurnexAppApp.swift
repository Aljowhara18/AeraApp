//
//  BurnexAppApp.swift
//  BurnexApp
//
//  Created by Jojo on 07/02/2026.
import SwiftUI

@main
struct AeraApp: App {
    // 🚀 المتغير السحري: يحفظ حالة المستخدم (هل خلص الاونبوردنق أو لا)
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    // تعريف الـ ViewModel إذا كنت تحتاجه في كامل التطبيق
    @StateObject private var viewModel = TestViewModel()

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                // إذا شافه قبل، يفتح الواجهة الرئيسية مباشرة
                MainTabView()
                    .environmentObject(viewModel)
            } else {
                // إذا أول مرة، يفتح صفحة الاونبوردنق
                OnboardingView()
                    .environmentObject(viewModel)
            }
        }
    }
}
