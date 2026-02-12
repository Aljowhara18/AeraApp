//
//  Home.swift
//  BurnexApp
//
//  Created by Jojo on 07/02/2026.
/**
import SwiftUI
import AVKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Alert العلوي w 338, h 71
                glassyAlert
                    .padding(.top, 10)
                
                Text("Your Status Right Now")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                ZStack {
                    // فيديو الكرة 314x312
                    VideoLoopPlayer(fileName: "Ball")
                        .opacity(0.08)
                        .frame(width: 500, height: 500)
                        .clipShape(Circle())
                        .shadow(color: .purple.opacity(0.3), radius: 30)
                    
                    // الأزرار
                    StatFlipButton(stat: viewModel.stats[0], pos: CGPoint(x: 120, y: -100)) { viewModel.flipCard(at: 0) }
                    StatFlipButton(stat: viewModel.stats[1], pos: CGPoint(x: -120, y: -40)) { viewModel.flipCard(at: 1) }
                    StatFlipButton(stat: viewModel.stats[2], pos: CGPoint(x: 120, y: 80)) { viewModel.flipCard(at: 2) }
                    StatFlipButton(stat: viewModel.stats[3], pos: CGPoint(x: -80, y: 150)) { viewModel.flipCard(at: 3) }
                }
                .frame(maxHeight: .infinity)
                
                Spacer(minLength: 100)
            }
        }
    }
    
    var glassyAlert: some View {
        HStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
            Text("Elevated Stress Detected Take a quick check in?")
                .font(.system(size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal)
        .frame(width: 338, height: 71)
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2)))
    }
}

// حل مشكلة "requires that CustomTabBar conform to View"
// تأكد أن أي Struct تستخدمه في الواجهة ينتهي بـ : View
struct StatFlipButton: View {
    let stat: StatModel
    let pos: CGPoint
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(stat.isFlipped ? stat.value : stat.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 110, height: 45)
                .background(BlurView(style: .systemThinMaterialDark))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1)))
                .rotation3DEffect(.degrees(stat.isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        }
        .offset(x: pos.x, y: pos.y)
    }
}
*/
/*
import SwiftUI
import AVKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            // الخلفية
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                // 1. Welcome - مع بادنق علوي كبير لضمان النزول تحت النوتش (Notch)
                Text("Welcome Faitmh")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.top, 60) // زيادة المسافة العلوية لضمان الظهور
                
                // 2. الـ Alert - يتوسط الشاشة
                glassyAlert
                    .padding(.horizontal, 30) // لضمان عدم خروجه من الجوانب
                    .padding(.top, 20)
                
                // 3. Your Status - محاذاة واضحة ومسافة آمنة
                Text("Your Status Right Now")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 30)
                    .padding(.top, 25)
                
                Spacer()
                
                // 4. منطقة الكرة (الفيديو) والأزرار
                ZStack {
                    // فيديو الكرة (10% أوباستي + لومينوستي)
                    VideoLoopPlayer(fileName: "Ball")
                        .opacity(0.10)
                        .blendMode(.luminosity)
                        .frame(width: 400, height: 400) // صغرنا الحجم قليلاً لضمان بقاء الأزرار داخل الشاشة
                        .clipShape(Circle())
                    
                    // الأزرار - تم تقريبها للمركز لضمان عدم خروجها عن الشاشة
                    StatFlipButton(stat: viewModel.stats[0], pos: CGPoint(x: 90, y: -100)) { viewModel.flipCard(at: 0) }
                    StatFlipButton(stat: viewModel.stats[1], pos: CGPoint(x: -90, y: -40)) { viewModel.flipCard(at: 1) }
                    StatFlipButton(stat: viewModel.stats[2], pos: CGPoint(x: 90, y: 80)) { viewModel.flipCard(at: 2) }
                    StatFlipButton(stat: viewModel.stats[3], pos: CGPoint(x: -60, y: 150)) { viewModel.flipCard(at: 3) }
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: 120)
            }
        }
    }
    
    // Alert View الموزون
    var glassyAlert: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
                .font(.system(size: 20))
            
            Text("Elevated Stress Detected Take a quick check in?")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 15)
        .frame(width: 330, height: 71) // تقليل العرض قليلاً للأمان
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
        )
    }
}

// Reintroduce StatFlipButton so it’s available to HomeView
struct StatFlipButton: View {
    let stat: StatModel
    let pos: CGPoint
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(stat.isFlipped ? stat.value : stat.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 110, height: 45)
                .background(BlurView(style: .systemThinMaterialDark))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1))
                )
                .rotation3DEffect(
                    .degrees(stat.isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .offset(x: pos.x, y: pos.y)
    }
}
*/
/*ضابط
import SwiftUI
import AVKit

struct HomeView: View {
    // نستخدم State للتحكم في التبويب المختار حالياً
    @State private var selectedTab = 0
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) { // جعل التاب بار في الأسفل
            
            // محتوى الصفحات بناءً على التبويب المختار
            Group {
                if selectedTab == 0 {
                    homeContent
                } else if selectedTab == 1 {
                    Color.black.overlay(Text("Analysis Screen").foregroundColor(.white)).ignoresSafeArea()
                } else {
                    Color.black.overlay(Text("Test Screen").foregroundColor(.white)).ignoresSafeArea()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // التاب بار المخصص
            customTabBar
        }
        .ignoresSafeArea(.keyboard)
    }
    
    // المحتوى الرئيسي لصفحة الهوم
    var homeContent: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Welcome Faitmh")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.top, 60)
                
                glassyAlert
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                
                Text("Your Status Right Now")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 30)
                    .padding(.top, 25)
                
                Spacer()
                
                ZStack {
                    VideoLoopPlayer(fileName: "Ball")
                        .opacity(0.10)
                        .blendMode(.luminosity)
                        .frame(width: 400, height: 400)
                        .clipShape(Circle())
                    
                    StatFlipButton(stat: viewModel.stats[0], pos: CGPoint(x: 90, y: -100)) { viewModel.flipCard(at: 0) }
                    StatFlipButton(stat: viewModel.stats[1], pos: CGPoint(x: -90, y: -40)) { viewModel.flipCard(at: 1) }
                    StatFlipButton(stat: viewModel.stats[2], pos: CGPoint(x: 90, y: 80)) { viewModel.flipCard(at: 2) }
                    StatFlipButton(stat: viewModel.stats[3], pos: CGPoint(x: -60, y: 150)) { viewModel.flipCard(at: 3) }
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: 120) // مساحة إضافية للتاب بار
            }
        }
    }
    
    // تصميم التاب بار المخصص
    var customTabBar: some View {
        HStack {
            TabBarButton(icon: "house.fill", label: "Home", isSelected: selectedTab == 0) { selectedTab = 0 }
            Spacer()
            TabBarButton(icon: "paperplane.fill", label: "Analysis", isSelected: selectedTab == 1) { selectedTab = 1 }
            Spacer()
            TabBarButton(icon: "pills.fill", label: "Test", isSelected: selectedTab == 2) { selectedTab = 2 }
        }
        .padding(.horizontal, 40)
        .frame(width: 350, height: 75)
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .clipShape(Capsule())
        .padding(.bottom, 25) // رفعة بسيطة عن أسفل الشاشة
    }

    var glassyAlert: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
                .font(.system(size: 20))
            Text("Elevated Stress Detected Take a quick check in?")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 15)
        .frame(width: 330, height: 71)
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 0.5))
    }
}

// مكون زر الـ Flip
struct StatFlipButton: View {
    let stat: StatModel
    let pos: CGPoint
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(stat.isFlipped ? stat.value : stat.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 110, height: 45)
                .background(BlurView(style: .systemThinMaterialDark))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1)))
                .rotation3DEffect(.degrees(stat.isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        }
        .offset(x: pos.x, y: pos.y)
    }
}

*/
// ضابط ع الدارك مود فقط

import SwiftUI
import AVKit

struct HomeView: View {
    @State private var selectedTab = 0
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // 1. خلفية التطبيق
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .ignoresSafeArea()

                // 2. محتوى الصفحات بناءً على التاب المختار
                Group {
                    if selectedTab == 0 {
                        homeContent
                    } else if selectedTab == 1 {
                        AnalysisView()
                    } else if selectedTab == 2 {
                        TestView() // تأكدي من وجود ملف بهذا الاسم في مشروعك
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
               
                // 3. التاب بار المخصص
//                customTabBar
//                    .padding()
             
            }
            .navigationBarHidden(true)
        }
    }
    
    var homeContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Welcome")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, 60)

            Text("Your Status Right Now")
                .font(.system(size: 22))
                .foregroundColor(.grayApp)
                .padding(.horizontal, 20)
                 .padding(.top, 15)
            
            glassyAlert
                .padding(.horizontal, 30)
                .padding(.top, 20)
            
            Spacer()
            
            // منطقة الكرة التفاعلية والأزرار (Stats)
            ZStack {
                Circle()
                    .foregroundStyle(.ball)
                    .frame(width: 300,height: 300)
                    .cornerRadius(90000)
                    .frame(width: 300, height: 300)
                
                VideoLoopPlayer(fileName: "Ball2")
                //.opacity(0.20)
                .blendMode(.luminosity)
                .frame(width: 300, height: 300)
                    .clipShape(Circle())
                
                StatFlipButton(stat: viewModel.stats[0], pos: CGPoint(x: 90, y: -100)) {
                    viewModel.flipCard(at: 0)
                }
                
                StatFlipButton(stat: viewModel.stats[1], pos: CGPoint(x: -90, y: -40)) {
                    viewModel.flipCard(at: 1)
                }
                
                StatFlipButton(stat: viewModel.stats[2], pos: CGPoint(x: 90, y: 80)) {
                    viewModel.flipCard(at: 2)
                }
            }
            //.frame(maxWidth: UIScreen.main.bounds.width)
            .offset(x: 40, y: -50)
            
            Spacer(minLength: 120)
        }
    }

//    var customTabBar: some View {
//        
//        HStack {
//            LocalTabBarButton(icon: "timelapse", label: "Rhythm", isSelected: selectedTab == 0) { selectedTab = 0 }
//            Spacer()
//            LocalTabBarButton(icon: "chart.xyaxis.line", label: "Analysis", isSelected: selectedTab == 1) { selectedTab = 1 }
//            Spacer()
//            LocalTabBarButton(icon: "clipboard", label: "Test", isSelected: selectedTab == 2) { selectedTab = 2 }
//        }
//        .padding(.horizontal, 4)
//        .frame(width: 350, height: 85)
//        .glassEffect()
//        .background(.text.opacity(0.3))
//        .clipShape(Capsule())
//        .padding(.bottom, 25)
//    }

    var glassyAlert: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
                .font(.system(size: 20))
            Text("Elevated Stress Detected Take a quick check in?")
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 15)
        .frame(width: 330, height: 71)
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 0.5))
    }
}

// MARK: - Subviews (التعريفات المفقودة التي سببت الأخطاء)

struct LocalTabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(label)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

struct StatFlipButton: View {
    let stat: StatModel
    let pos: CGPoint
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(stat.isFlipped ? stat.value : stat.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 110, height: 45)
                .glassEffect(in:.rect(cornerRadius: 100))
                .background(.white.opacity(0.1))
                .cornerRadius(100)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1)))
        }
        .offset(x: pos.x, y: pos.y)
    }
}

#Preview{ HomeView()
}
