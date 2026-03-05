import SwiftUI

struct Question {
    let text: String
    let category: String
}

struct BurnoutCheckView: View {
    @ObservedObject var viewModel: TestViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var step = 0 // 0: Start, 1: Questions, 2: Result, 3: Reflection
    @State private var currentIdx = 0
    @State private var isMovingBack = false
    @State private var answers: [Int?] = Array(repeating: nil, count: 6)
    
    @State private var reflectionTitle: String = ""
    @State private var reflectionDetails: String = ""
    @State private var ballOpacity: Double = 0.6
    
    @State private var showInfoCard: Bool = false
    @State private var infoText: String = ""
    
    let questions = [
        Question(text: "I feel emotionally exhausted because of my work.", category: "EE"),
        Question(text: "I feel drained and worn out at the end of the workday.", category: "EE"),
        Question(text: "I have become less caring toward people related to my work.", category: "DP"),
        Question(text: "I feel emotionally detached or indifferent toward my work.", category: "DP"),
        Question(text: "I feel that my work makes a meaningful difference.", category: "PA"),
        Question(text: "I feel competent and accomplished in what I do at work.", category: "PA")
    ]
    
    var totalScore: Int {
        answers.compactMap { $0 }.reduce(0, +)
    }
    
    var resultTitle: String {
        totalScore > 12 ? "Early signs of burnout" : "You're doing great!"
    }
    
    var resultMessage: String {
        totalScore > 12 ?
        "Remember to prioritize your well being today." :
        "You have a healthy balance right now. Keep practicing your daily habits to stay energized!"
    }
    
    var resultButtonText: String {
        totalScore > 12 ? "Next" : "Next"
    }
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if step != 3 { headerView }
                
                switch step {
                case 0:
                    startPage.transition(.opacity)
                case 1:
                    questionsPage
                case 2:
                    resultPage.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 3:
                    reflectionPage.transition(.move(edge: .bottom))
                default:
                    EmptyView()
                }
            }
            
            // Overlay زر التعجب
                        if showInfoCard {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.spring()) { showInfoCard = false }
                                }
                            
                            VStack(spacing: 16) {
                                Text("Info")
                                    .font(.system(size: 22,weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(infoText)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Button(action: {
                                    withAnimation(.spring()) { showInfoCard = false }
                                }) {
                                    Text("Close")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.text)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                    
                                }
                            }
                            .padding()
                            .frame(width: 280)
                            .background(
                                    Color.black.opacity(0.5)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.4), lineWidth: 1) 
                                        )
                                )
                            .cornerRadius(20)
                            .transition(.scale.combined(with: .opacity))
                            .zIndex(2)
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: step)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentIdx)
                }
    
    // MARK: - Header
    var headerView: some View {
        ZStack {
            HStack {
                // زر العودة - الآن متجاوب مع العربي والإنجليزي
                Button(action: {
                    if step == 1 {
                        if currentIdx > 0 {
                            isMovingBack = true
                            withAnimation(.easeInOut(duration: 0.6)) { currentIdx -= 1 }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { isMovingBack = false }
                        } else {
                            withAnimation { step = 0 }
                        }
                    } else if step > 0 {
                        withAnimation { step -= 1 }
                    } else {
                        dismiss()
                    }
                }) {
                    // استخدام backward يجعل السهم ينقلب تلقائياً حسب اللغة
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20) // حواف متساوية لضمان المسافة في الجهتين
                }
                
                Spacer() // سيدفع الزر لليمين في العربي ولليسار في الإنجليزي تلقائياً
            }
            
            // العنوان يبقى في المنتصف بفضل وجوده داخل ZStack
            Text(LocalizedStringKey(step == 2 ? "Your Result" : "Balance Check"))
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(height: 44)
        .padding(.top, 10)
    }
//    var headerView: some View {
//        ZStack {
//            HStack {
//                // زر الباك
//                Button(action: {
//                    if step == 1 {
//                        if currentIdx > 0 {
//                            isMovingBack = true
//                            withAnimation(.easeInOut(duration: 0.6)) { currentIdx -= 1 }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { isMovingBack = false }
//                        } else {
//                            withAnimation { step = 0 }
//                        }
//                    } else if step > 0 {
//                        withAnimation { step -= 1 }
//                    } else {
//                        dismiss()
//                    }
//                }) {
//                    Image(systemName: "chevron.backward")
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundColor(.white)
//                        .padding(.leading, 20)
//                }
//                Spacer()
//                
//                //info
////                Button {
////                    withAnimation(.spring()) {
////                        showInfoCard = true
////                        infoText = NSLocalizedString(
////                            "Sources: This check is based on the Maslach Burnout Inventory (MBI) to ensure scientific accuracy.",
////                            comment: ""
////                        )
////                    }
////                } label: {
////                    Image(systemName: "exclamationmark.circle")
////                        .font(.system(size: 24))
////                        .foregroundColor(.white)
////                        .padding(.trailing, 20)
////                }
//            }
//            
//            Text(LocalizedStringKey(step == 2 ? "Your Result" : "Balance Check"))
//                .font(.system(size: 22, weight: .bold))
//                .foregroundColor(.white)
//        }
//        .frame(height: 44)
//        .padding(.top, 10)
//    }


    // MARK: - 1. Start Page
    var startPage: some View {
        VStack {
            Spacer()
            
            Text("Answer a few questions to check for early signs of burnout")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer().frame(height: 51)
            
            VideoLoopPlayer(fileName: "Ball2")
                .frame(width: 220, height: 220)
                .clipShape(Circle())
                .grayscale(1.0)
                .opacity(ballOpacity)
            
            Spacer()
            
            warningView
            
            Button(action: { withAnimation { step = 1 } }) {
                Text("Begin")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 254, height: 49)
                    .glassEffect(in:.rect(cornerRadius: 12))
                    .background(.text.opacity(0.3))
                    .cornerRadius(12)
            }
            .padding(.bottom, 40)
        }
    }

    // MARK: - 2. Questions Page
    var questionsPage: some View {
        VStack {
            Text("\(currentIdx + 1)/\(questions.count)")
                .foregroundColor(.white.opacity(0.6))
                .padding(.top, 20)
            Spacer()
            QuestionCard(
                text: NSLocalizedString(questions[currentIdx].text, comment: ""),
                selected: $answers[currentIdx]
            )
            .id(currentIdx)
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
            .onChange(of: answers[currentIdx]) { newValue in
                guard newValue != nil && !isMovingBack else { return }
                if currentIdx == questions.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        withAnimation { step = 2 }
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        if !isMovingBack {
                            withAnimation(.easeInOut(duration: 0.6)) { currentIdx += 1 }
                        }
                    }
                }
            }
            Spacer()
            Color.clear.frame(height: 49).padding(.bottom, 40)
        }
    }

    // MARK: - 3. Result Page
    var resultPage: some View {
        VStack(spacing: 40) {
            Spacer()
            VideoLoopPlayer(fileName: "Ball2")
                .frame(width: 240, height: 240).clipShape(Circle())
                .colorMultiply(totalScore > 12 ? .red : .green)
            
            VStack(spacing: 15) {
                Text(LocalizedStringKey(resultTitle))
                    .font(.system(size: 28, weight: .bold)).foregroundColor(.white)
            
                Text(LocalizedStringKey(resultMessage))
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center).padding(.horizontal, 40)
            }
            Spacer()
            Button(action: { withAnimation { step = 3 } }) {
                Text(LocalizedStringKey(resultButtonText))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 254, height: 49)
                    .glassEffect(in:.rect(cornerRadius: 12))
                    .background(.text.opacity(0.3))
                    .cornerRadius(12)
            }
            .padding(.bottom, 40)
        }
    }

    // MARK: - 4. Reflection Page
    var reflectionPage: some View {
        VStack(spacing: 25) {
            HStack {
                Button(action: { withAnimation { step = 2 } }) {
                    Image(systemName: "xmark")
                        .circleBackground()
                }
                Spacer()
                Text("Reflection").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                Spacer()
                Button(action: {
                    if !reflectionTitle.isEmpty { viewModel.addReflection(title: reflectionTitle, content: reflectionDetails) }
                    dismiss()
                }) {
                    Image(systemName: "checkmark").circleBackground()
                }
            }
            .padding(.horizontal, 20).padding(.top, 10)

            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 60)
                    Text("Reflect on your day")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        + Text("  (Optional)").font(.system(size: 14)).foregroundColor(.white)
                    
                    Spacer().frame(height: 64)
                    Text("Define this feeling")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                    
                    TextField("E.g. Overwhelmed at work, meetings", text: $reflectionTitle)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12).foregroundColor(.white)
                        .onChange(of: reflectionTitle) { newValue in
                            // تقييد العنوان بـ 50 حرف ليبقى مظهره جيداً في الكروت
                            if newValue.count > 50 { reflectionTitle = String(newValue.prefix(50)) }
                        }
                }

                Spacer().frame(height: 32)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("What’s weighing on you?")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $reflectionDetails)
                            .frame(height: 150)
                            .scrollContentBackground(.hidden)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            // تقييد النص بـ 100 حرف
                            .onChange(of: reflectionDetails) { newValue in
                                if newValue.count > 100 {
                                    reflectionDetails = String(newValue.prefix(100))
                                }
                            }
                        
                        if reflectionDetails.isEmpty {
                            Text("Capture your thoughts")
                                .foregroundColor(.white.opacity(0.3))
                                .padding(.horizontal, 14)
                                .padding(.top, 18)
                        }
                    }
                    .overlay(
                        // استخدام التنسيق لدمج الرقم الحالي مع الكلمة المترجمة
                        HStack(spacing: 2) {
                            Text("\(reflectionDetails.count)")
                            Text("/")
                            Text(LocalizedStringKey("Limit")) // هنا سيتم البحث عن الترجمة
                        }
                        .font(.caption)
                        .foregroundColor(reflectionDetails.count >= 100 ? .red : .gray)
                        .padding(10),
                        alignment: .bottomTrailing
                    )
                }
            }
            .padding(.horizontal, 25)
            Spacer()
        }
    }

    var warningView: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 15,weight: .bold))
                .foregroundColor(.yellow)
            Text("For awareness only This does not replace professional medical advice")
                .font(.system(size: 14,weight: .light))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 30)
    }
}

extension View {
    func circleBackground() -> some View {
        self.font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .background(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
    }
}
#Preview {
    BurnoutCheckView(viewModel: TestViewModel())
}
