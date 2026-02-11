//
//  BurnoutCheckView.swift
//  BurnexApp
//
//  Created by Najla Almuqati on 23/08/1447 AH.
//

import SwiftUI

// تعريف هيكل السؤال
struct Question {
    let text: String
    let category: String
}

struct BurnoutCheckView: View {
    @State private var step = 0 // 0: البداية، 1: الأسئلة، 2: النتيجة
    @State private var currentIdx = 0
    @State private var selectedOption: Int? = nil
    @State private var totalScore = 0
    
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
            // --- إضافة الخلفية هنا ---
            Image("Background")
                .resizable()
//                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            if step == 0 {
                // --- شاشة البداية ---
                VStack(spacing: 0) {
                    ZStack {
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Circle().fill(Color.white.opacity(0.1)))
                            }
                            Spacer()
                        }
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

                    VideoLoopPlayer(fileName: "Ball")
                        .frame(width: 220, height: 220)
                        .clipShape(Circle())
                        .grayscale(1.0)
                        .opacity(0.6)
                        .shadow(color: .black.opacity(0.4), radius: 20)

                    Spacer()

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("This test is for awareness purposes only and dose not replace consulting specialists.")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)

                    Button(action: {
                        withAnimation { step = 1 }
                    }) {
                        Text("Start")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
                
            } else if step == 1 {
                // --- شاشة الأسئلة ---
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                if currentIdx > 0 { currentIdx -= 1 } else { step = 0 }
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Circle().fill(Color.white.opacity(0.1)))
                        }
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
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(RoundedRectangle(cornerRadius: 15).fill(selectedOption == nil ? Color.gray.opacity(0.2) : Color.white.opacity(0.1)))
                    }
                    .disabled(selectedOption == nil)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            } else {
                // --- شاشة النتيجة ---
                resultPage
            }
        }
    }
    
    var resultPage: some View {
        VStack(spacing: 30) {
            Text("Your Result").font(.largeTitle).bold().foregroundColor(.white)
            
            VideoLoopPlayer(fileName: "Ball")
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .colorMultiply(totalScore > 12 ? .red : .green)
                
            Text(totalScore > 12 ? "You've been feeling tired lately." : "You're doing great!")
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            Button("Retake") {
                withAnimation {
                    step = 0;
                    currentIdx = 0;
                    totalScore = 0;
                    selectedOption = nil
                }
            }
            .foregroundColor(.gray)
        }
    }
    
    func nextAction() {
        totalScore += (selectedOption ?? 0)
        withAnimation(.spring()) {
            if currentIdx < 5 {
                currentIdx += 1
                selectedOption = nil
            } else {
                step = 2
            }
        }
    }
}

#Preview {
    BurnoutCheckView()
}

