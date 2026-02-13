//
//  TestView.swift
//  BurnexApp
//
//  Created by Jojo on 10/02/2026.
import SwiftUI

// MARK: - Main View
struct TestView: View {
    @StateObject private var viewModel = TestViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. الخلفية الأساسية - تم استبدال اللون بالصورة مع منطق الحجم الكامل
                Image("Background") // تأكد أن الحرف الأول كبير كما في الكود الأول
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .ignoresSafeArea()
                
                // 2. المحتوى فوق الخلفية
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Test")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    // 🔹 البانر (startTestBanner)
                    NavigationLink(destination: BurnoutCheckView()) {
                        startTestBanner
                    }

                    HStack {
                        Text("Your Reflection")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Button("Show More") {}
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.reflections) { reflection in
                                ReflectionCard(reflection: reflection) {
                                    viewModel.toggleCard(id: reflection.id)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                // التغبيش يطبق على المحتوى والخلفية معاً عند الحاجة
                .blur(radius: viewModel.reflections.contains(where: { $0.isExpanded }) ? 10 : 0)
                
                // 3. الطبقة العلوية عند تكبير الكارد (Expanded Card Overlay)
                if let expandedItem = viewModel.reflections.first(where: { $0.isExpanded }) {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.closeCard(id: expandedItem.id)
                        }
                    
                    ExpandedCardView(reflection: expandedItem) {
                        viewModel.toggleCard(id: expandedItem.id)
                    }
                }
            }
        }
    }

    // القسم الخاص بالبانر
    private var startTestBanner: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                Text("Start New Test")
                    .font(.headline)
            }
            Text("Elevated Stress detected, help us understand your rhythm")
                .font(.caption)
                .opacity(0.8)
            
            Text("Start the test")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 35)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

// MARK: - Supporting Views 

struct ReflectionCard: View {
    let reflection: ReflectionModel
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .background(Color.white.opacity(0.05))
                Text(reflection.title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 130, height: 160)
        }
    }
}

struct ExpandedCardView: View {
    let reflection: ReflectionModel
    let action: () -> Void
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.1))
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .padding(10)
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                
                if reflection.isFlipped {
                    VStack {
                        HStack { dot; Spacer(); dot }
                        Spacer()
                        HStack { dot; Spacer(); dot }
                    }
                    .padding(30)
                }
                
                if !reflection.isFlipped {
                    Text(reflection.title)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.white)
                } else {
                    Text(reflection.content)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(40)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
            }
            .frame(width: 300, height: 320)
            .rotation3DEffect(.degrees(reflection.isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .onTapGesture { action() }
        }
    }
    private var dot: some View {
        Circle().fill(Color.white.opacity(0.6)).frame(width: 5, height: 5)
    }
}



#Preview {
    TestView()
}
