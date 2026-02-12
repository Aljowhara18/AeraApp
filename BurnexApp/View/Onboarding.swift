//
//  Onboarding.swift
//  BurnexApp
//
//  Created by Jojo on 10/02/2026.

// ماعرفت كيف اسوي التوهج اللي بفيقما
import SwiftUI

struct OnboardingView: View {
    // MARK: - Properties
    @State private var step = 0
    @State private var contentOpacity: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var hintBouncing: CGFloat = 0.0
    @State private var imageOpacity: Double = 0.0
    
    // ستايت للتحكم في الصفحات اليدوية والنافقيشن
    @State private var manualPage = 0
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Color.black.ignoresSafeArea()
                
                // --- محتوى الصفحات بناءً على الـ Step ---
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
                
                // --- زر Skip (ينقل للهوم مباشرة) ---
                if step > 6 && manualPage < 2 {
                    Button(action: {
                        navigateToHome = true // تعديل: الآن ينقل لصفحة الهوم فوراً
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.top, 20)
                            .padding(.trailing, 25)
                    }
                    .transition(.opacity)
                }
            }
            // ربط النافقيشن بالوجهة المطلوبة
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }

    // MARK: - Splash View
    private var splashView: some View {
        ZStack{
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            Text("Burnex")
                 .font(.system(size: 42, weight: .ultraLight, design: .serif))
                 .foregroundColor(.white)
                 .tracking(12)
                 .opacity(contentOpacity)
                 .frame(maxWidth: .infinity, maxHeight: .infinity)
                 .onAppear {
                     withAnimation(.easeIn(duration: 1.0)) { contentOpacity = 1.0 }
                     DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                         withAnimation {
                             contentOpacity = 0
                             step = 1
                         }
                     }
                 }
         } }
 

    // MARK: - Hint View
    private var hintView: some View {
        VStack(spacing: 30) {
            Text("Your Rhythm Starts With A Touch")
                .font(.system(size: 24, weight: .light))
                .foregroundColor(.white)
            
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.7))
                .offset(y: hintBouncing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever()) {
                hintBouncing = 12
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.8)) {
                step = 2
            }
        }
    }

    // MARK: - Automatic Animation (Orbs)
    private var automaticAnimationView: some View {
        VStack(spacing: 40) {
            Spacer()
            Image(currentImageName(for: step))
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .scaleEffect(pulseScale)
                .opacity(imageOpacity)
                .transition(.opacity)
                .id(step)
            
            Text(currentInstruction(for: step))
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .opacity(imageOpacity)
            Spacer()
        }
        .onAppear {
            startAutomaticSequence()
        }
    }

    // MARK: - Manual Swiping Section
    private var manualOnboardingView: some View {
        VStack {
            TabView(selection: $manualPage) {
                manualPageContent(image: "AppleWatch", text: "Make Sure To Connect Your App With\nYour Apple Watch For Better Analysis")
                    .tag(0)
                
                manualPageContent(image: "HealthIcon", text: "Or Enter Your Daily Data Manualy\nFrom Health App")
                    .tag(1)
                
                manualPageContent(image: "Health", text: "Or Enter Your Daily Data Manualy\nFrom Health App", showButton: true)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // النقاط (3 اندكيترز)
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(manualPage == index ? Color.white : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .animation(.spring(), value: manualPage)
                }
            }
            .padding(.bottom, manualPage == 2 ? 20 : 50)
        }
    }

    private func manualPageContent(image: String, text: String, showButton: Bool = false) -> some View {
        VStack(spacing: 40) {
            Spacer()
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
            
            Text(text)
                .font(.system(size: 19, weight: .light))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
            
            if showButton {
                Button(action: {
                    navigateToHome = true // ينقل للهوم
                }) {
                    Text("Start with Burnex")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.5), lineWidth: 1))
                        .background(Color.blue.opacity(0.2))
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 30)
            }
        }
    }

    // MARK: - Logic Helpers
    func startAutomaticSequence() {
        triggerImageVisuals()
        if step < 6 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    step += 1
                    startAutomaticSequence()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation { step = 7 }
            }
        }
    }
    
    func triggerImageVisuals() {
        imageOpacity = 0
        withAnimation(.easeOut(duration: 0.6)) { imageOpacity = 1.0 }
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.06
        }
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

