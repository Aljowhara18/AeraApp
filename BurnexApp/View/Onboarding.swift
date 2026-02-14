//
//  Onboarding.swift
//  BurnexApp
//
//  Created by Jojo on 10/02/2026.

// ماعرفت كيف اسوي التوهج اللي بفيقما
import SwiftUI

struct OnboardingView: View {
    // MARK: - Properties
    // ربط الحالة بذاكرة الجهاز لضمان عدم ظهور الاونبوردنق مرة أخرى بعد الانتهاء
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    @State private var step = 0
    @State private var contentOpacity: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var hintBouncing: CGFloat = 0.0
    @State private var imageOpacity: Double = 0.0
    
    @State private var manualPage = 0
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Color.black.ignoresSafeArea()
                
                // --- المحتوى الرئيسي بناءً على المرحلة ---
                Group {
                    if step == 0 {
                        splashView
                    } else if step == 1 {
                        hintView
                    } else if step >= 2 && step <= 6 {
                        automaticAnimationView
                    } else if step > 6 {
                        manualOnboardingView
                    }
                }
                
                // --- زر Skip الذكي ---
                if step > 0 && !(step > 6 && manualPage == 1) {
                    Button(action: {
                        if step <= 6 {
                            // إذا كان في مرحلة الأورب، ينقله للمرحلة اليدوية
                            withAnimation { step = 7 }
                        } else {
                            // إذا كان في المرحلة اليدوية، ينهي الاونبوردنق تماماً
                            withAnimation { hasSeenOnboarding = true }
                        }
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.top, 20)
                            .padding(.trailing, 25)
                    }
                    .transition(.opacity)
                    .zIndex(2)
                }
            }
        }
    }

    // MARK: - 1. Splash View
    private var splashView: some View {
        ZStack {
            Image("Background").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
            Text("Burnex")
                .font(.system(size: 42, weight: .ultraLight, design: .serif))
                .foregroundColor(.white).tracking(12).opacity(contentOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) { contentOpacity = 1.0 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { contentOpacity = 0; step = 1 }
                    }
                }
        }
    }

    // MARK: - 2. Hint View
    private var hintView: some View {
        VStack(spacing: 30) {
            Text("Your Rhythm Starts With A Touch").font(.system(size: 24, weight: .light)).foregroundColor(.white)
            Image(systemName: "hand.tap.fill").font(.system(size: 40)).foregroundColor(.white.opacity(0.7)).offset(y: hintBouncing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { withAnimation(.easeInOut(duration: 0.6).repeatForever()) { hintBouncing = 12 } }
        .contentShape(Rectangle())
        .onTapGesture { withAnimation(.easeInOut(duration: 0.8)) { step = 2 } }
    }

    // MARK: - 3. Automatic Animation (Orbs)
    private var automaticAnimationView: some View {
        VStack(spacing: 0) {
            Spacer()
            // عرض الصور من المركز (Cross-fade)
            ZStack {
                ForEach(2...6, id: \.self) { i in
                    if step == i {
                        Image(currentImageName(for: i))
                            .resizable().scaledToFit()
                            .frame(width: i == 2 ? 240 : 300, height: i == 2 ? 240 : 300)
                            .scaleEffect(pulseScale)
                            // تحكم بمكان الصورة الأولى (BlueTail) من هنا
                            .offset(y: i == 2 ? 60 : 0)
                            .transition(.opacity.animation(.easeInOut(duration: 0.8)))
                    }
                }
            }
            .frame(maxWidth: .infinity).frame(height: 300)
            
            // نصوص ثابتة المكان لضمان ثبات التصميم
            ZStack {
                ForEach(2...6, id: \.self) { i in
                    if step == i {
                        Text(currentInstruction(for: i)).font(.system(size: 20, weight: .light)).foregroundColor(.white)
                            .multilineTextAlignment(.center).padding(.horizontal, 30)
                            .transition(.opacity.animation(.easeInOut(duration: 0.8)))
                    }
                }
            }
            .frame(height: 100).frame(maxWidth: .infinity).padding(.top, 40)
            Spacer()
        }
        .onAppear { startAutomaticSequence() }
    }

    // MARK: - 4. Manual Swiping Section
    private var manualOnboardingView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // النص في الأعلى (ثابت)
            ZStack {
                if manualPage == 0 {
                    Text("Make Sure To Connect Your App With\nYour Apple Watch For Better Analysis")
                        .transition(.opacity)
                } else {
                    Text("Or Enter Your Daily Data Manually\nFrom Health App")
                        .transition(.opacity)
                }
            }
            .font(.system(size: 19, weight: .light)).foregroundColor(.white)
            .multilineTextAlignment(.center).padding(.horizontal, 30)
            .frame(height: 80).padding(.bottom, 20)

            // الصور (تتحرك عند السحب)
            TabView(selection: $manualPage) {
                Image("AppleWatch").resizable().scaledToFit().frame(width: 320, height: 320).tag(0)
                Image("HealthIcon").resizable().scaledToFit().frame(width: 320, height: 320).tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 320)
            
            // الإنديكيتور تحت الصور مباشرة
            HStack(spacing: 8) {
                ForEach(0..<2) { index in
                    Circle()
                        .fill(manualPage == index ? Color.white : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .animation(.spring(), value: manualPage)
                }
            }
            .padding(.top, 30)
            
            Spacer()
            
            // زر البدء النهائي (بتصميم زجاجي مطابق لزر البدء الأول)
            VStack {
                if manualPage == 1 {
                    Button(action: {
                        withAnimation { hasSeenOnboarding = true }
                    }) {
                        Text("Start with Burnex")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 254, height: 49)
                            .glassEffect(in:.rect(cornerRadius: 12))
                            .background(.text.opacity(0.3))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .frame(height: 60).padding(.bottom, 40)
        }
        .animation(.easeInOut, value: manualPage)
    }

    // MARK: - Logic Helpers
    func startAutomaticSequence() {
        guard step <= 6 else { return }
        // توقيت ذكي: سريع لأول صورتين (اكتمال الدائرة) وبطيء للبقية (للقراءة)
        let delay: Double = (step == 2 || step == 3) ? 0.6 : 3.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if step < 6 {
                withAnimation { step += 1; startAutomaticSequence() }
            } else if step == 6 {
                withAnimation { step = 7 }
            }
        }
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) { pulseScale = 1.05 }
    }

    func currentImageName(for s: Int) -> String {
        let names = [2: "BlueTail", 3: "Bluehalf", 4: "BlueGlow", 5: "RedGlow", 6: "PurbleGlow"]
        return names[s] ?? ""
    }
    
    func currentInstruction(for s: Int) -> String {
        if s <= 4 { return "This Is Your Calm" }
        if s == 5 { return "But Life Gets Chaotic\nYour Rhythm Is Disrupted" }
        return "With Aura You Don't Just Go Back\nYou Move Forward Balanced And Wiser"
    }
}
#Preview {
    OnboardingView()
}

