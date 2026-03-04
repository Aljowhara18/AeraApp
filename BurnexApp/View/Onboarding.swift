//
//  Onboarding.swift
//  BurnexApp
//
//  Created by Jojo on 10/02/2026.

// ماعرفت كيف اسوي التوهج اللي بفيقما
//import SwiftUI
//
//struct OnboardingView: View {
//    // MARK: - Properties
//    // ربط الحالة بذاكرة الجهاز لضمان عدم ظهور الاونبوردنق مرة أخرى بعد الانتهاء
//    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
//    
//    @State private var step = 0
//    @State private var contentOpacity: Double = 0.0
//    @State private var pulseScale: CGFloat = 1.0
//    @State private var hintBouncing: CGFloat = 0.0
//    @State private var imageOpacity: Double = 0.0
//    
//    @State private var manualPage = 0
//    @State private var navigateToHome = false
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .topTrailing) {
//                Color.black.ignoresSafeArea()
//                
//                // --- المحتوى الرئيسي بناءً على المرحلة ---
//                Group {
//                    if step == 0 {
//                        splashView
//                    } else if step == 1 {
//                        hintView
//                    } else if step >= 2 && step <= 6 {
//                        automaticAnimationView
//                    } else if step > 6 {
//                        manualOnboardingView
//                    }
//                }
//                
//                // --- زر Skip الذكي ---
//                if step > 0 && !(step > 6 && manualPage == 1) {
//                    Button(action: {
//                        if step <= 6 {
//                            // إذا كان في مرحلة الأورب، ينقله للمرحلة اليدوية
//                            withAnimation { step = 7 }
//                        } else {
//                            // إذا كان في المرحلة اليدوية، ينهي الاونبوردنق تماماً
//                            withAnimation { hasSeenOnboarding = true }
//                        }
//                    }) {
//                        Text("Skip")
//                            .font(.system(size: 16, weight: .medium))
//                            .foregroundColor(.white.opacity(0.6))
//                            .padding(.top, 20)
//                            .padding(.trailing, 25)
//                    }
//                    .transition(.opacity)
//                    .zIndex(2)
//                }
//            }
//        }
//    }
//
//    // MARK: - 1. Splash View
//    private var splashView: some View {
//        ZStack {
//            Image("Background").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
//            Text("Burnex")
//                .font(.system(size: 42, weight: .ultraLight, design: .serif))
//                .foregroundColor(.white).tracking(12).opacity(contentOpacity)
//                .onAppear {
//                    withAnimation(.easeIn(duration: 1.0)) { contentOpacity = 1.0 }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                        withAnimation { contentOpacity = 0; step = 1 }
//                    }
//                }
//        }
//    }
//
//    // MARK: - 2. Hint View
//    private var hintView: some View {
//        VStack(spacing: 30) {
//            Text("Your Rhythm Starts With A Touch").font(.system(size: 24, weight: .light)).foregroundColor(.white)
//            Image(systemName: "hand.tap.fill").font(.system(size: 40)).foregroundColor(.white.opacity(0.7)).offset(y: hintBouncing)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear { withAnimation(.easeInOut(duration: 0.6).repeatForever()) { hintBouncing = 12 } }
//        .contentShape(Rectangle())
//        .onTapGesture { withAnimation(.easeInOut(duration: 0.8)) { step = 2 } }
//    }
//
//    // MARK: - 3. Automatic Animation (Orbs)
//    private var automaticAnimationView: some View {
//        VStack(spacing: 0) {
//            Spacer()
//            // عرض الصور من المركز (Cross-fade)
//            ZStack {
//                ForEach(2...6, id: \.self) { i in
//                    if step == i {
//                        Image(currentImageName(for: i))
//                            .resizable().scaledToFit()
//                            .frame(width: i == 2 ? 240 : 300, height: i == 2 ? 240 : 300)
//                            .scaleEffect(pulseScale)
//                            // تحكم بمكان الصورة الأولى (BlueTail) من هنا
//                            .offset(y: i == 2 ? 60 : 0)
//                            .transition(.opacity.animation(.easeInOut(duration: 0.8)))
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity).frame(height: 300)
//            
//            // نصوص ثابتة المكان لضمان ثبات التصميم
//            ZStack {
//                ForEach(2...6, id: \.self) { i in
//                    if step == i {
//                        Text(currentInstruction(for: i)).font(.system(size: 20, weight: .light)).foregroundColor(.white)
//                            .multilineTextAlignment(.center).padding(.horizontal, 30)
//                            .transition(.opacity.animation(.easeInOut(duration: 0.8)))
//                    }
//                }
//            }
//            .frame(height: 100).frame(maxWidth: .infinity).padding(.top, 40)
//            Spacer()
//        }
//        .onAppear { startAutomaticSequence() }
//    }
//
//    // MARK: - 4. Manual Swiping Section
//    private var manualOnboardingView: some View {
//        VStack(spacing: 0) {
//            Spacer()
//            
//            // النص في الأعلى (ثابت)
//            ZStack {
//                if manualPage == 0 {
//                    Text("Make Sure To Connect Your App With\nYour Apple Watch For Better Analysis")
//                        .transition(.opacity)
//                } else {
//                    Text("Or Enter Your Daily Data Manually\nFrom Health App")
//                        .transition(.opacity)
//                }
//            }
//            .font(.system(size: 19, weight: .light)).foregroundColor(.white)
//            .multilineTextAlignment(.center).padding(.horizontal, 30)
//            .frame(height: 80).padding(.bottom, 20)
//
//            // الصور (تتحرك عند السحب)
//            TabView(selection: $manualPage) {
//                Image("AppleWatch").resizable().scaledToFit().frame(width: 320, height: 320).tag(0)
//                Image("HealthIcon").resizable().scaledToFit().frame(width: 320, height: 320).tag(1)
//            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            .frame(height: 320)
//            
//            // الإنديكيتور تحت الصور مباشرة
//            HStack(spacing: 8) {
//                ForEach(0..<2) { index in
//                    Circle()
//                        .fill(manualPage == index ? Color.white : Color.gray.opacity(0.5))
//                        .frame(width: 8, height: 8)
//                        .animation(.spring(), value: manualPage)
//                }
//            }
//            .padding(.top, 30)
//            
//            Spacer()
//            
//            // زر البدء النهائي (بتصميم زجاجي مطابق لزر البدء الأول)
//            VStack {
//                if manualPage == 1 {
//                    Button(action: {
//                        withAnimation { hasSeenOnboarding = true }
//                    }) {
//                        Text("Start with Burnex")
//                            .font(.system(size: 20, weight: .bold))
//                            .foregroundColor(.white)
//                            .frame(width: 254, height: 49)
//                            .glassEffect(in:.rect(cornerRadius: 12))
//                            .background(.text.opacity(0.3))
//                            .cornerRadius(12)
//                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
//                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
//                    }
//                    .transition(.move(edge: .bottom).combined(with: .opacity))
//                }
//            }
//            .frame(height: 60).padding(.bottom, 40)
//        }
//        .animation(.easeInOut, value: manualPage)
//    }
//
//    // MARK: - Logic Helpers
//    func startAutomaticSequence() {
//        guard step <= 6 else { return }
//        // توقيت ذكي: سريع لأول صورتين (اكتمال الدائرة) وبطيء للبقية (للقراءة)
//        let delay: Double = (step == 2 || step == 3) ? 0.6 : 3.0
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            if step < 6 {
//                withAnimation { step += 1; startAutomaticSequence() }
//            } else if step == 6 {
//                withAnimation { step = 7 }
//            }
//        }
//        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) { pulseScale = 1.05 }
//    }
//
//    func currentImageName(for s: Int) -> String {
//        let names = [2: "BlueTail", 3: "Bluehalf", 4: "BlueGlow", 5: "RedGlow", 6: "PurbleGlow"]
//        return names[s] ?? ""
//    }
//    
//    func currentInstruction(for s: Int) -> LocalizedStringKey {
//        if s <= 4 { return LocalizedStringKey("This Is Your Balance\nStable and in control") }
//        if s == 5 { return LocalizedStringKey("But Life Gets Chaotic\nYour Rhythm Is Disrupted") }
//        return LocalizedStringKey("With Burnex You Don't Just Go Back\nYou Move Forward Balanced And Wiser")
//    }
//
//}
//#Preview {
//    OnboardingView()
//}

// كود الجوهره



// كودي
import SwiftUI

struct OnboardingView: View {
    // MARK: - 1. Properties
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    @State private var state: OnboardingStep = .splash
    @State private var manualPage = 0
    @State private var orbScale: CGFloat = 1.0
    
    // Animation Variables
    @State private var contentOpacity: Double = 0.0
    @State private var blueLine1Opacity: Double = 0.0
    @State private var blueLine2Opacity: Double = 0.0
    @State private var redOpacity: Double = 0.0
    @State private var purplePart1Opacity: Double = 0.0
    @State private var purplePart2Opacity: Double = 0.0
    
    @State private var opacityBlueGlow: Double = 0.0
    @State private var opacityRedGlow: Double = 0.0
    @State private var opacityPurpleGlow: Double = 0.0
    
    @State private var manualViewOpacity: Double = 0.0
    @State private var manualViewOffset: CGFloat = 20.0
    @State private var backgroundOpacity: Double = 0.0
    @State private var hintBouncing: CGFloat = 0.0

    // MARK: - 2. Enums
    enum OnboardingStep {
        case splash, hint, calm, chaos, balance1, balance2, fadeOut, manual
    }

    // MARK: - 3. Main Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            finalAtmosphere
            
            Group {
                switch state {
                case .splash: splashView
                case .hint:   hintView
                case .manual: manualOnboardingView
                default:      storyView
                }
            }
            
            if shouldShowSkip { skipButton }
        }
    }
}

// MARK: - 4. Splash & Hint Views
private extension OnboardingView {
    var splashView: some View {
        ZStack {
            Image("Background").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
            Text("Burnex")
                .font(.system(size: 42, weight: .ultraLight, design: .serif))
                .foregroundColor(.white).tracking(12).opacity(contentOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) { contentOpacity = 1.0 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { contentOpacity = 0; state = .hint }
                    }
                }
        }
    }
    
    var hintView: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("Your Rhythm Starts With A Touch").font(.system(size: 24, weight: .light))
            Image(systemName: "hand.tap.fill").font(.system(size: 50))
                .foregroundColor(.white.opacity(0.8)).offset(y: hintBouncing)
            Spacer()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onAppear { withAnimation(.easeInOut(duration: 0.6).repeatForever()) { hintBouncing = 12 } }
        .onTapGesture { startStory() }
    }
}

// MARK: - 5. Story View
private extension OnboardingView {
    var storyView: some View {
        ZStack {
            ZStack {
                Image("BlueGlow").resizable().scaledToFit().frame(width: 340, height: 340)
                    .scaleEffect(state == .calm ? orbScale : 1.0).opacity(opacityBlueGlow)
                Image("RedGlow").resizable().scaledToFit().frame(width: 360, height: 360)
                    .scaleEffect(state == .chaos ? orbScale : 1.0).opacity(opacityRedGlow)
                Image("PurbleGlow").resizable().scaledToFit().frame(width: 340, height: 340)
                    .scaleEffect((state == .balance1 || state == .balance2) ? orbScale : 1.0).opacity(opacityPurpleGlow)
            }
            .mask(radialMask).frame(maxHeight: .infinity).offset(y: -50)
            
            VStack {
                Spacer()
                ZStack {
                    blueTextGroup; redTextGroup; purpleText1; purpleText2
                }
                .font(.system(size: 24, weight: .light)).foregroundColor(.white).multilineTextAlignment(.center)
                .frame(height: 140).padding(.horizontal, 30).padding(.bottom, 130)
            }
        }
    }
}

// MARK: - 6. Manual Setup View
private extension OnboardingView {
    var manualOnboardingView: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 80)
            Text(manualPage == 0 ? "Make Sure To Connect Your App With\nYour Apple Watch For Better Analysis" : "Or Enter Your Daily Data Manually\nFrom Health App")
                .font(.system(size: 19, weight: .light)).multilineTextAlignment(.center)
                .foregroundColor(.white).frame(height: 80).padding(.horizontal, 30)
            Spacer(minLength: 20)
            TabView(selection: $manualPage) {
                Image("AppleWatch").resizable().scaledToFit().frame(width: 280, height: 280).tag(0)
                Image("HealthIcon").resizable().scaledToFit().frame(width: 280, height: 280).tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)).frame(height: 300)
            pageControl.padding(.top, 40)
            Spacer()
            if manualPage == 1 { startAppButton.padding(.bottom, 60).transition(.opacity) }
            else { Color.clear.frame(height: 50).padding(.bottom, 60) }
        }
        .opacity(manualViewOpacity).offset(y: manualViewOffset)
    }
}

// MARK: - 7. Animation Logic (الحماية الحديدية)
private extension OnboardingView {
    func startStory() {
        state = .calm
        triggerHaptic(.soft)
        withAnimation(.easeIn(duration: 1.5)) { opacityBlueGlow = 1.0 }
        withAnimation(.easeIn(duration: 0.8)) { blueLine1Opacity = 1.0 }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            guard state != .manual else { return }
            withAnimation(.easeIn(duration: 0.8)) { blueLine2Opacity = 1.0 }
        }
        
        startBreathing(mode: .calm)
        
        // Red Chaos
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            guard state != .manual else { return }
            state = .chaos
            triggerHaptic(.heavy)
            withAnimation(.easeOut(duration: 0.5)) { blueLine1Opacity = 0; blueLine2Opacity = 0 }
            withAnimation(.easeInOut(duration: 0.8)) { opacityBlueGlow = 0; opacityRedGlow = 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                guard state != .manual else { return }
                withAnimation(.easeIn(duration: 0.5)) { redOpacity = 1.0 }
            }
            startBreathing(mode: .chaos)
        }
        
        // Purple Balance
        DispatchQueue.main.asyncAfter(deadline: .now() + 12.0) {
            guard state != .manual else { return }
            state = .balance1
            triggerNotificationHaptic(.success)
            withAnimation(.easeOut(duration: 0.5)) { redOpacity = 0 }
            withAnimation(.easeInOut(duration: 1.5)) { opacityRedGlow = 0; opacityPurpleGlow = 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                guard state != .manual else { return }
                withAnimation(.easeIn(duration: 0.8)) { purplePart1Opacity = 1.0 }
            }
            startBreathing(mode: .calm)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 16.0) {
            guard state != .manual else { return }
            state = .balance2
            withAnimation(.easeOut(duration: 0.5)) { purplePart1Opacity = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard state != .manual else { return }
                withAnimation(.easeIn(duration: 0.8)) { purplePart2Opacity = 1.0 }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 21.0) {
            guard state != .manual else { return }
            state = .fadeOut
            withAnimation(.easeOut(duration: 1.0)) { opacityPurpleGlow = 0; purplePart2Opacity = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                guard state != .manual else { return }
                state = .manual
                triggerHaptic(.medium)
                withAnimation(.easeIn(duration: 1.2)) { manualViewOpacity = 1.0; manualViewOffset = 0; backgroundOpacity = 1.0 }
            }
        }
    }
    
    func skipAction() {
        triggerHaptic(.light)
        if state == .manual {
            withAnimation { hasSeenOnboarding = true }
        } else {
            // الانتقال الفوري للساعة وقتل أي تايمر قادم
            state = .manual
            withAnimation(.easeOut(duration: 0.5)) {
                opacityBlueGlow = 0; opacityRedGlow = 0; opacityPurpleGlow = 0
                blueLine1Opacity = 0; blueLine2Opacity = 0; redOpacity = 0
                purplePart1Opacity = 0; purplePart2Opacity = 0
            }
            withAnimation(.easeIn(duration: 0.8)) {
                manualViewOpacity = 1.0; manualViewOffset = 0; backgroundOpacity = 1.0
            }
        }
    }

    func startBreathing(mode: BreathingMode) {
        orbScale = 1.0
        let duration = mode == .chaos ? 1.2 : 3.5
        let scale: CGFloat = mode == .chaos ? 1.1 : 1.15
        withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) { orbScale = scale }
    }
    enum BreathingMode { case calm, chaos }
}

// MARK: - 8. Shared Components (الزر الزجاجي)
private extension OnboardingView {
    var blueTextGroup: some View {
        VStack(spacing: 12) {
            Text("This Is Your Balance").opacity(blueLine1Opacity).offset(y: blueLine1Opacity == 1 ? 0 : 5)
            Text("Stable And In Control").opacity(blueLine2Opacity).offset(y: blueLine2Opacity == 1 ? 0 : 5)
        }
    }
    var redTextGroup: some View { VStack(spacing: 12) { Text("But Life Gets Chaotic"); Text("Your Rhythm Is Disrupted") }.opacity(redOpacity) }
    var purpleText1: some View { Text("With Burnex You Don't Just Go Back").opacity(purplePart1Opacity) }
    var purpleText2: some View { VStack(spacing: 12) { Text("You Move Forward"); Text("Balanced And Wiser") }.opacity(purplePart2Opacity) }
    
    var skipButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: skipAction) {
                    Text("Skip").font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.6)).padding([.top, .trailing], 30)
                }
            }
            Spacer()
        }
    }
    
    var startAppButton: some View {
        Button(action: { withAnimation { hasSeenOnboarding = true } }) {
            Text("Start with Burnex")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 254, height: 49)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
        }
    }
    
    var pageControl: some View {
        HStack(spacing: 8) {
            ForEach(0..<2) { i in
                Circle().fill(manualPage == i ? Color.white : Color.white.opacity(0.3)).frame(width: 8, height: 8)
            }
        }
    }
    
    var finalAtmosphere: some View {
        RadialGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.05, blue: 0.3).opacity(0.4), .black]), center: .center, startRadius: 5, endRadius: 500)
            .ignoresSafeArea().opacity(backgroundOpacity)
    }
    
    var radialMask: some View {
        RadialGradient(gradient: Gradient(stops: [.init(color: .white, location: 0.5), .init(color: .clear, location: 0.95)]), center: .center, startRadius: 100, endRadius: 170)
    }
    
    var shouldShowSkip: Bool {
        state != .splash && !(state == .manual && manualPage == 1)
    }
    
    func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) { UIImpactFeedbackGenerator(style: style).impactOccurred() }
    func triggerNotificationHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) { UINotificationFeedbackGenerator().notificationOccurred(type) }

}
#Preview { OnboardingView() }


