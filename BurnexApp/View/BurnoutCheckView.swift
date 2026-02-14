//
//  BurnoutCheckView.swift
//  BurnexApp
//
//  Created by Najla Almuqati on 23/08/1447 AH.
//

//import SwiftUI
//
//// تعريف هيكل السؤال
//struct Question {
//    let text: String
//    let category: String
//}
//
//struct BurnoutCheckView: View {
//    @State private var step = 0
//    @State private var currentIdx = 0
//    @State private var selectedOption: Int? = nil
//    @State private var totalScore = 0
//    
//    let questions = [
//        Question(text: "I feel emotionally exhausted because of my work.", category: "EE"),
//        Question(text: "I feel drained and worn out at the end of the workday.", category: "EE"),
//        Question(text: "I have become less caring toward people related to my work.", category: "DP"),
//        Question(text: "I feel emotionally detached or indifferent toward my work.", category: "DP"),
//        Question(text: "I feel that my work makes a meaningful difference.", category: "PA"),
//        Question(text: "I feel competent and accomplished in what I do at work.", category: "PA")
//    ]
//
//    var body: some View {
//        ZStack {
//            // --- إضافة الخلفية هنا ---
//            Image("Background")
//                .resizable()
////                .aspectRatio(contentMode: .fill)
//                .ignoresSafeArea()
//            
//            if step == 0 {
//                // --- شاشة البداية ---
//                VStack(spacing: 0) {
//                    ZStack {
//                        HStack {
//                            Button(action: {}) {
//                                Image(systemName: "chevron.left")
//                                    .font(.system(size: 18, weight: .bold))
//                                    .foregroundColor(.white)
//                                    .padding(10)
//                                    .background(Circle().fill(Color.white.opacity(0.1)))
//                            }
//                            Spacer()
//                        }
//                        Text("Burnout Check")
//                            .font(.system(size: 22, weight: .bold))
//                            .foregroundColor(.white)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 10)
//
//                    Spacer()
//
//                    Text("We’ll ask you a few quick questions to understand your burnout level")
//                        .font(.system(size: 20, weight: .medium))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal, 30)
//
//                    Spacer()
//
//                    VideoLoopPlayer(fileName: "Ball")
//                        .frame(width: 220, height: 220)
//                        .clipShape(Circle())
//                        .grayscale(1.0)
//                        .opacity(0.6)
//                        .shadow(color: .black.opacity(0.4), radius: 20)
//
//                    Spacer()
//
//                    HStack(alignment: .top, spacing: 8) {
//                        Image(systemName: "exclamationmark.triangle.fill")
//                            .foregroundColor(.red)
//                        Text("This test is for awareness purposes only and dose not replace consulting specialists.")
//                            .font(.system(size: 14))
//                            .foregroundColor(.white.opacity(0.7))
//                            .multilineTextAlignment(.leading)
//                    }
//                    .padding(.horizontal, 40)
//                    .padding(.bottom, 30)
//
//                    Button(action: {
//                        withAnimation { step = 1 }
//                    }) {
//                        Text("Start")
//                            .font(.system(size: 20, weight: .bold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 60)
//                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
//                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
//                    }
//                    .padding(.horizontal, 40)
//                    .padding(.bottom, 40)
//                }
//                
//            } else if step == 1 {
//                // --- شاشة الأسئلة ---
//                VStack {
//                    HStack {
//                        Button(action: {
//                            withAnimation {
//                                if currentIdx > 0 { currentIdx -= 1 } else { step = 0 }
//                            }
//                        }) {
//                            Image(systemName: "chevron.left")
//                                .foregroundColor(.white)
//                                .padding(10)
//                                .background(Circle().fill(Color.white.opacity(0.1)))
//                        }
//                        Spacer()
//                        Text("\(currentIdx + 1)/6")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                        Spacer()
//                        Spacer().frame(width: 40)
//                    }
//                    .padding(.horizontal, 25)
//                    .padding(.top, 20)
//                    
//                    Spacer()
//                    
//                    QuestionCard(text: questions[currentIdx].text, selected: $selectedOption)
//                        .id(currentIdx)
//                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
//                    
//                    Spacer()
//                    
//                    Button(action: nextAction) {
//                        Text(currentIdx == 5 ? "Done" : "Next")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 60)
//                            .background(RoundedRectangle(cornerRadius: 15).fill(selectedOption == nil ? Color.gray.opacity(0.2) : Color.white.opacity(0.1)))
//                    }
//                    .disabled(selectedOption == nil)
//                    .padding(.horizontal, 40)
//                    .padding(.bottom, 30)
//                }
//            } else {
//                // --- شاشة النتيجة ---
//                resultPage
//            }
//        }
//    }
//    
//    var resultPage: some View {
//        VStack(spacing: 30) {
//            Text("Your Result").font(.largeTitle).bold().foregroundColor(.white)
//            
//            VideoLoopPlayer(fileName: "Ball")
//                .frame(width: 250, height: 250)
//                .clipShape(Circle())
//                .colorMultiply(totalScore > 12 ? .red : .green)
//                
//            Text(totalScore > 12 ? "You've been feeling tired lately." : "You're doing great!")
//                .font(.title3)
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
//                .padding()
//            Button("Retake") {
//                withAnimation {
//                    step = 0;
//                    currentIdx = 0;
//                    totalScore = 0;
//                    selectedOption = nil
//                }
//            }
//            .foregroundColor(.gray)
//        }
//    }
//    
//    func nextAction() {
//        totalScore += (selectedOption ?? 0)
//        withAnimation(.spring()) {
//            if currentIdx < 5 {
//                currentIdx += 1
//                selectedOption = nil
//            } else {
//                step = 2
//            }
//        }
//    }
//}
//
//#Preview {
//    BurnoutCheckView()
//}

import SwiftUI

// 1. تعريف هيكل السؤال
struct Question {
    let text: String
    let category: String
}

struct BurnoutCheckView: View {
    @ObservedObject var viewModel: TestViewModel
    @Environment(\.dismiss) var dismiss
    @State private var step = 0
    @State private var currentIdx = 0
    @State private var selectedOption: Int? = nil
    @State private var totalScore = 0
    
    @State private var reflectionTitle: String = ""
    @State private var reflectionDetails: String = ""
    
    @State private var showSuccessPopup = false
    @State private var navigateToTestView = false
    
    let questions = [
        Question(text: "I feel emotionally exhausted because of my work.", category: "EE"),
        Question(text: "I feel drained and worn out at the end of the workday.", category: "EE"),
        Question(text: "I have become less caring toward people related to my work.", category: "DP"),
        Question(text: "I feel emotionally detached or indifferent toward my work.", category: "DP"),
        Question(text: "I feel that my work makes a meaningful difference.", category: "PA"),
        Question(text: "I feel competent and accomplished in what I do at work.", category: "PA")
    ]

    var body: some View {
        ZStack {
            // --- الخلفية ---
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            if step == 0 {
                startPage
            } else if step == 1 {
                questionsPage
            } else {
                resultPage
            }
            
            // --- تعديل طبقة الكارد ليكون الخلفية ضبابية (نفس تأثير Expanded) ---
            if showSuccessPopup {
                Color.black.opacity(0.6) // تعتيم خفيف
                    .background(.ultraThinMaterial.opacity(0.8)) // التغبيش (Blur) للخلفية
                    .ignoresSafeArea()
                
                successPopupView
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
                    .zIndex(1)
            }
            
            NavigationLink(destination: TestView(viewModel: viewModel), isActive: $navigateToTestView) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - شاشة البداية
    var startPage: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    Spacer()
                }
                .frame(height: 44)
                
                Text("Burnout Check")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Spacer()

            Text("We’ll ask you a few quick questions to understand your burnout level")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer()

            VideoLoopPlayer(fileName: "Ball2")
                .frame(width: 220, height: 220)
                .clipShape(Circle())
                .grayscale(1.0)
                .opacity(0.6)
                .shadow(color: .black.opacity(0.4), radius: 20)

            Spacer()

            warningView

            Button(action: { withAnimation { step = 1 } }) {
                Text("Start")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 254, height: 49)
                    .glassEffect(in:.rect(cornerRadius: 12))
                    .background(.text.opacity(0.3))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    // MARK: - شاشة الأسئلة
    var questionsPage: some View {
        VStack {
            HStack {
                Spacer().frame(width: 40)
                Spacer()
                Text("\(currentIdx + 1)/6")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Spacer().frame(width: 40)
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)
            
            Spacer()
            
            QuestionCard(text: questions[currentIdx].text, selected: $selectedOption)
                .id(currentIdx)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            
            Spacer()
            
            Button(action: nextAction) {
                Text(currentIdx == 5 ? "Done" : "Next")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 254, height: 49)
                    .glassEffect(in:.rect(cornerRadius: 12))
                    .background(.text.opacity(0.3))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
                    .background(RoundedRectangle(cornerRadius: 15).fill(selectedOption == nil ? Color.gray.opacity(0.2) : Color.white.opacity(0.1)))
            }
            .disabled(selectedOption == nil)
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
    }

    // MARK: - شاشة النتيجة
    var resultPage: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 25) {
                    VideoLoopPlayer(fileName: "Ball2")
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .colorMultiply(totalScore > 12 ? .red : .green)
                        
                    Text(totalScore > 12 ? "You've been feeling tired lately Take care of yourself today" : "You're doing great!")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Your Reflection (optional)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Titel")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Write title", text: $reflectionTitle)
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("More details")
                                .font(.caption)
                                .foregroundColor(.gray)
                            ZStack(alignment: .bottomTrailing) {
                                TextEditor(text: $reflectionDetails)
                                    .frame(height: 100)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))
                                    .foregroundColor(.white)
                                    .onChange(of: reflectionDetails) { newValue in
                                        if newValue.count > 100 {
                                            reflectionDetails = String(newValue.prefix(100))
                                        }
                                    }
                                    
                                Text("\(reflectionDetails.count)/100")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                    .padding(8)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
            }
            
            Button(action: {
                let trimmedTitle = reflectionTitle.trimmingCharacters(in: .whitespaces)
                if !trimmedTitle.isEmpty {
                    viewModel.addReflection(
                        title: trimmedTitle,
                        content: reflectionDetails.isEmpty ? "No details provided" : reflectionDetails
                    )
                }

                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showSuccessPopup = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        showSuccessPopup = false
                        dismiss()
                    }
                }
            }) {
                Text("Release")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 254, height: 49)
                    .glassEffect(in:.rect(cornerRadius: 12))
                    .background(.text.opacity(0.3))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    // MARK: - الكارد المنبثق المائي المحدث (مطابق لـ ExpandedCardView)
    var successPopupView: some View {
        ZStack {
            ZStack {
                // 1. الخلفية المائية (نفس ExpandedCardView)
                RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1))
                
                // 2. الإطار الداخلي
                RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1).padding(10)
                
                // 3. الإطار الخارجي
                RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                
                // 4. النقاط الجمالية في الزوايا
                VStack {
                    HStack {
                        Circle().fill(Color.white.opacity(0.4)).frame(width: 6, height: 6)
                        Spacer()
                        Circle().fill(Color.white.opacity(0.4)).frame(width: 6, height: 6)
                    }
                    Spacer()
                    HStack {
                        Circle().fill(Color.white.opacity(0.4)).frame(width: 6, height: 6)
                        Spacer()
                        Circle().fill(Color.white.opacity(0.4)).frame(width: 6, height: 6)
                    }
                }
                .padding(25)

                // 5. محتوى النص
                VStack(spacing: 12) {
                    Text("It's out now")
                        .font(.system(size: 26, weight: .medium))
                    Text("Take a deep breath")
                        .font(.system(size: 30, weight: .bold))
                }
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            }
            .frame(width: 300, height: 320)
            .shadow(color: .black.opacity(0.2), radius: 20)
        }
    }

    var warningView: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text("This test is for awareness purposes only and does not replace consulting specialists.")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 30)
    }

    func nextAction() {
        totalScore += (selectedOption ?? 0)
        withAnimation(.spring()) {
            if currentIdx < 5 {
                currentIdx += 1
                selectedOption = nil
            } else { step = 2 }
        }
    }
}

#Preview {
    BurnoutCheckView(viewModel: TestViewModel())
}
