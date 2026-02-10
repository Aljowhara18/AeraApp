//
//  Onboarding.swift
//  BurnexApp
//
//  Created by Jojo on 10/02/2026.

// ماعرفت كيف اسوي التوهج اللي بفيقما
import SwiftUI

import SwiftUI

struct OnboardingView: View {
    @State private var step = 0
    // Animation States
    @State private var circleTrim: CGFloat = 0.0
    @State private var fillOpacity: Double = 0.0
    @State private var contentOpacity: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var hintBouncing: CGFloat = 0.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // --- المرحلة 1: اسم التطبيق (Splash) ---
            if step == 0 {
                Text("Burnex")
                    .font(.system(size: 42, weight: .ultraLight, design: .serif))
                    .foregroundColor(.white)
                    .tracking(12)
                    .opacity(contentOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5)) { contentOpacity = 1.0 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                contentOpacity = 0
                                step = 1
                            }
                        }
                    }
            }
            
            // --- المرحلة 2: تلميح اللمس (Tab Hint) ---
            if step == 1 {
                VStack(spacing: 30) {
                    Text("Your Rhythm Starts With A Touch")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.white)
                    
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.7))
                        .offset(y: hintBouncing)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.8).repeatForever()) {
                                hintBouncing = 15
                            }
                        }
                }
                .opacity(step == 1 ? 1 : 0)
                .onTapGesture {
                    withAnimation { step = 2 }
                }
            }
            
            // --- المرحلة 3: الدوائر المتحركة (The Orbs) ---
            if step >= 2 {
                VStack {
                    Spacer()
                    
                    ZStack {
                        // 1. التوهج الخلفي البعيد (Glow Background)
                        Circle()
                            .fill(currentOrbColor.opacity(0.15))
                            .frame(width: 400, height: 400)
                            .blur(radius: 60)
                        
                        // 2. الدائرة المنقطة (الجزيئات كما في الصورة)
                        Circle()
                            .trim(from: 0, to: circleTrim)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [currentOrbColor.opacity(0), currentOrbColor, currentOrbColor.opacity(0.5)]),
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [1, 6])
                            )
                            .frame(width: 280, height: 280)
                            .rotationEffect(.degrees(-90))
                            .blur(radius: 0.5)
                        
                        // 3. التعبئة الداخلية المشعة (The Core)
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [currentOrbColor.opacity(0.9), currentOrbColor.opacity(0.2), .clear]),
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 120
                                )
                            )
                            .frame(width: 250, height: 250)
                            .opacity(fillOpacity)
                            .scaleEffect(pulseScale)
                    }
                    
                    Spacer()
                    
                    // النصوص والوصف
                    Text(currentInstruction)
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .id(step) // للتأكد من إعادة تشغيل الأنميشن عند تغيير النص
                    
                    Spacer()
                    
                    // --- المرحلة الأخيرة: زر الدخول ---
                    if step == 4 {
                        Button(action: {
                            // انتقلي هنا للـ HomeView
                        }) {
                            Text("Start with Burnex")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Capsule().fill(Color.white))
                                .padding(.horizontal, 40)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if step < 4 {
                        withAnimation(.spring()) {
                            step += 1
                            triggerOrbAnimation()
                        }
                    }
                }
                .onAppear { triggerOrbAnimation() }
            }
        }
    }
    
    // وظيفة تشغيل أنميشن الدائرة "نفس الصورة"
    func triggerOrbAnimation() {
        circleTrim = 0
        fillOpacity = 0
        
        // 1. رسم الإطار المنقط (الجزيئات)
        withAnimation(.easeOut(duration: 1.5)) {
            circleTrim = 1.0
        }
        
        // 2. إظهار التوهج الداخلي بعد اكتمال الرسم قليلاً
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 1.2)) {
                fillOpacity = 1.0
            }
            // 3. حركة النبض المستمرة
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.08
            }
        }
    }

    // البيانات (الألوان والنصوص)
    var currentOrbColor: Color {
        switch step {
        case 2: return Color(red: 0.0, green: 0.8, blue: 1.0) // Cyan
        case 3: return Color.blue
        case 4: return Color.red
        default: return Color.cyan
        }
    }
    
    var currentInstruction: String {
        switch step {
        case 2: return "This Is Your Calm"
        case 3: return "Stay In Control"
        case 4: return "But Life Gets Chaotic\nYour Rhythm Is Disrupted"
        default: return ""
        }
    }
}

#Preview {
    OnboardingView()
}
