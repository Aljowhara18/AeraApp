//import SwiftUI
//
//struct Question {
//    let text: String
//    let category: String
//}
//
//struct BurnoutCheckView: View {
//    @ObservedObject var viewModel: TestViewModel
//    @Environment(\.dismiss) var dismiss
//    @State private var step = 0
//    @State private var currentIdx = 0
//    @State private var selectedOption: Int? = nil
//    @State private var totalScore = 0
//    
//    @State private var reflectionTitle: String = ""
//    @State private var reflectionDetails: String = ""
//    
//    @State private var showSuccessPopup = false
//    @State private var navigateToTestView = false
//    
//    // متغير جديد للتحكم في ظهور الكورة بشكل مستقل
//    @State private var ballOpacity: Double = 0.6
//
//    let questions = [
//        Question(text: "I feel emotionally exhausted because of my work.", category: "EE"),
//        Question(text: "I feel drained and worn out at the end of the workday.", category: "EE"),
//        Question(text: "I have become less caring toward people related to my work.", category: "DP"),
//        Question(text: "I feel emotionally detached or indifferent toward my work.", category: "DP"),
//        Question(text: "I feel that my work makes a meaningful difference.", category: "PA"),
//        Question(text: "I feel competent and accomplished in what I do at work.", category: "PA")
//    ]
//
//    var body: some View {
//        ZStack {
//            Image("Background")
//                .resizable()
//                .ignoresSafeArea()
//            
//            if step == 0 {
//                startPage
//                    .transition(.opacity)
//            } else if step == 1 {
//                questionsPage
//                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
//            } else {
//                resultPage
//                    .transition(.opacity)
//            }
//            
//            if showSuccessPopup {
//                Color.black.opacity(0.6)
//                    .background(.ultraThinMaterial.opacity(0.8))
//                    .ignoresSafeArea()
//                
//                successPopupView
//                    .transition(.scale(scale: 0.8).combined(with: .opacity))
//                    .zIndex(1)
//            }
//            
//            NavigationLink(destination: TestView(viewModel: viewModel), isActive: $navigateToTestView) {
//                EmptyView()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//    // MARK: - شاشة البداية
//    var startPage: some View {
//        VStack(spacing: 0) {
//            ZStack {
//                HStack {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 20, weight: .semibold))
//                            .foregroundColor(.white)
//                            .padding(.leading, 20)
//                    }
//                    Spacer()
//                }
//                .frame(height: 44)
//                
//                Text("Burnout Check")
//                    .font(.system(size: 22, weight: .bold))
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 10)
//
//            Spacer()
//
//            Text("We’ll ask you a few quick questions to understand your burnout level")
//                .font(.system(size: 20, weight: .medium))
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 30)
//
//            Spacer()
//
//            // الكورة الآن مرتبطة بـ ballOpacity
//            VideoLoopPlayer(fileName: "Ball2")
//                .frame(width: 220, height: 220)
//                .clipShape(Circle())
//                .grayscale(1.0)
//                .opacity(ballOpacity)
//                .shadow(color: .black.opacity(0.4), radius: 20)
//                .animation(.easeOut(duration: 0.2), value: ballOpacity)
//
//            Spacer()
//
//            warningView
//
//            Button(action: {
//                // الحل الجذري: إخفاء الكورة أولاً ثم الانتقال لضمان عدم التعليق
//                withAnimation(.easeOut(duration: 0.2)) {
//                    ballOpacity = 0
//                }
//                
//                // تأخير بسيط جداً للانتقال لضمان سلاسة المعالج
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//                        step = 1
//                    }
//                }
//            }) {
//                Text("Start")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
//                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
//            }
//            .padding(.horizontal, 40)
//            .padding(.bottom, 40)
//        }
//    }
//
//    // MARK: - شاشة الأسئلة
//    var questionsPage: some View {
//        VStack {
//            HStack {
//                Spacer().frame(width: 40)
//                Spacer()
//                Text("\(currentIdx + 1)/6")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                Spacer()
//                Spacer().frame(width: 40)
//            }
//            .padding(.horizontal, 25)
//            .padding(.top, 20)
//            
//            Spacer()
//            
//            // إضافة drawingGroup لتحسين أداء حركة الكارد والخيارات
//            QuestionCard(text: questions[currentIdx].text, selected: $selectedOption)
//                .id(currentIdx)
//                .drawingGroup()
//                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
//            
//            Spacer()
//            
//            Button(action: nextAction) {
//                Text(currentIdx == 5 ? "Done" : "Next")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
//                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
//            }
//            .disabled(selectedOption == nil)
//            .padding(.horizontal, 40)
//            .padding(.bottom, 30)
//        }
//    }
//
//    // MARK: - شاشة النتيجة (بدون تغييرات جذرية لضمان الثبات)
//    var resultPage: some View {
//        VStack(spacing: 0) {
//            ScrollView {
//                VStack(spacing: 25) {
//                    VideoLoopPlayer(fileName: "Ball2")
//                        .frame(width: 200, height: 200)
//                        .clipShape(Circle())
//                        .colorMultiply(totalScore > 12 ? .red : .green)
//                        
//                    Text(totalScore > 12 ? "You've been feeling tired lately Take care of yourself today" : "You're doing great!")
//                        .font(.title3)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Your Reflection (optional)")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Titel")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            TextField("Write title", text: $reflectionTitle)
//                                .padding()
//                                .background(Color.black.opacity(0.3))
//                                .cornerRadius(12)
//                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))
//                                .foregroundColor(.white)
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("More details")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            ZStack(alignment: .bottomTrailing) {
//                                TextEditor(text: $reflectionDetails)
//                                    .frame(height: 100)
//                                    .scrollContentBackground(.hidden)
//                                    .padding(8)
//                                    .background(Color.black.opacity(0.3))
//                                    .cornerRadius(12)
//                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))
//                                    .foregroundColor(.white)
//                                    
//                                Text("\(reflectionDetails.count)/100")
//                                    .font(.system(size: 10))
//                                    .foregroundColor(.gray)
//                                    .padding(8)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                }
//                .padding(.vertical, 20)
//            }
//            
//            Button(action: {
//                let trimmedTitle = reflectionTitle.trimmingCharacters(in: .whitespaces)
//                if !trimmedTitle.isEmpty {
//                    viewModel.addReflection(title: trimmedTitle, content: reflectionDetails)
//                }
//                withAnimation(.spring()) { showSuccessPopup = true }
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                    withAnimation {
//                        showSuccessPopup = false
//                        dismiss()
//                    }
//                }
//            }) {
//                Text("Release")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
//                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
//            }
//            .padding(.horizontal, 40)
//            .padding(.bottom, 40)
//        }
//    }
//
//    var successPopupView: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1))
//            RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.3), lineWidth: 1.5)
//            VStack(spacing: 12) {
//                Text("It's out now").font(.system(size: 26, weight: .medium))
//                Text("Take a deep breath").font(.system(size: 30, weight: .bold))
//            }
//            .foregroundColor(.white)
//        }
//        .frame(width: 300, height: 320)
//    }
//
//    var warningView: some View {
//        HStack(alignment: .top, spacing: 8) {
//            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
//            Text("This test is for awareness purposes only and does not replace consulting specialists.").font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
//        }
//        .padding(.horizontal, 40).padding(.bottom, 30)
//    }
//
//    func nextAction() {
//        totalScore += (selectedOption ?? 0)
//        // تقليل قوة الأنيميشن لضمان عدم تعليق الخيارات
//        withAnimation(.interpolatingSpring(stiffness: 120, damping: 15)) {
//            if currentIdx < 5 {
//                currentIdx += 1
//                selectedOption = nil
//            } else { step = 2 }
//        }
//    }
//}
//import SwiftUI
//
//struct Question {
//    let text: String
//    let category: String
//}
//
//struct BurnoutCheckView: View {
//    @ObservedObject var viewModel: TestViewModel
//    @Environment(\.dismiss) var dismiss
//    @State private var step = 0
//    @State private var currentIdx = 0
//    @State private var selectedOption: Int? = nil
//    @State private var totalScore = 0
//    
//    @State private var reflectionTitle: String = ""
//    @State private var reflectionDetails: String = ""
//    
//    @State private var showSuccessPopup = false
//    @State private var navigateToTestView = false
//    
//    // متغير جديد للتحكم في ظهور الكورة بشكل مستقل
//    @State private var ballOpacity: Double = 0.6
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
//            Image("Background")
//                .resizable()
//                .ignoresSafeArea()
//            
//            if step == 0 {
//                startPage
//                    .transition(.opacity)
//            } else if step == 1 {
//                questionsPage
//                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
//            } else {
//                resultPage
//                    .transition(.opacity)
//            }
//            
//            if showSuccessPopup {
//                Color.black.opacity(0.6)
//                    .background(.ultraThinMaterial.opacity(0.8))
//                    .ignoresSafeArea()
//                
//                successPopupView
//                    .transition(.scale(scale: 0.8).combined(with: .opacity))
//                    .zIndex(1)
//            }
//            
//            NavigationLink(destination: TestView(viewModel: viewModel), isActive: $navigateToTestView) {
//                EmptyView()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//    // MARK: - شاشة البداية
//    var startPage: some View {
//        VStack(spacing: 0) {
//            ZStack {
//                HStack {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 20, weight: .semibold))
//                            .foregroundColor(.white)
//                            .padding(.leading, 20)
//                    }
//                    Spacer()
//                }
//                .frame(height: 44)
//                
//                Text("Burnout Check")
//                    .font(.system(size: 22, weight: .bold))
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 10)
//
//            Spacer()
//
//            Text("We’ll ask you a few quick questions to understand your burnout level")
//                .font(.system(size: 20, weight: .medium))
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 30)
//
//            Spacer()
//
//            VideoLoopPlayer(fileName: "Ball2")
//                .frame(width: 220, height: 220)
//                .clipShape(Circle())
//                .grayscale(1.0)
//                .opacity(ballOpacity)
//                .shadow(color: .black.opacity(0.4), radius: 20)
//                .animation(.easeOut(duration: 0.2), value: ballOpacity)
//
//            Spacer()
//
//            warningView
//
//            Button(action: {
//                withAnimation(.easeOut(duration: 0.2)) {
//                    ballOpacity = 0
//                }
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//                        step = 1
//                    }
//                }
//            }) {
//                Text("Start")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
//                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
//            }
//            .padding(.horizontal, 40)
//            .padding(.bottom, 40)
//        }
//    }
//
//    // MARK: - شاشة الأسئلة (التعديلات هنا)
//    var questionsPage: some View {
//        VStack {
//            // العداد مع الأسهم المحدثة < 1/6 >
//            HStack(spacing: 20) {
//                // سهم لليسار (يرجع للسؤال السابق)
//                Button(action: {
//                    if currentIdx > 0 {
//                        withAnimation {
//                            currentIdx -= 1
//                            selectedOption = nil
//                        }
//                    }
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(currentIdx > 0 ? .white : .white.opacity(0.3))
//                }
//                .disabled(currentIdx == 0)
//
//                Text("\(currentIdx + 1)/6")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 60)
//
//                // سهم لليمين (ينتقل للسؤال التالي إذا تم الاختيار)
//                Button(action: {
//                    if currentIdx < 5 && selectedOption != nil {
//                        nextAction()
//                    }
//                }) {
//                    Image(systemName: "chevron.right")
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(currentIdx < 5 && selectedOption != nil ? .white : .white.opacity(0.3))
//                }
//                .disabled(currentIdx == 5 || selectedOption == nil)
//            }
//            .padding(.top, 20)
//            
//            Spacer()
//            
//            QuestionCard(text: questions[currentIdx].text, selected: $selectedOption)
//                .id(currentIdx)
//                .drawingGroup()
//                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
//            
//            Spacer()
//            
//            // الزر السفلي (يتغير من Next إلى Done)
//            Button(action: nextAction) {
//                Text(currentIdx == 5 ? "Done" : "Next")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
//                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
//            }
//            .disabled(selectedOption == nil)
//            .padding(.horizontal, 40)
//            .padding(.bottom, 30)
//        }
//    }
//
//    // MARK: - شاشة النتيجة
//    var resultPage: some View {
//        VStack(spacing: 0) {
//            ScrollView {
//                VStack(spacing: 25) {
//                    VideoLoopPlayer(fileName: "Ball2")
//                        .frame(width: 200, height: 200)
//                        .clipShape(Circle())
//                        .colorMultiply(totalScore > 12 ? .red : .green)
//                        
//                    Text(totalScore > 12 ? "You've been feeling tired lately Take care of yourself today" : "You're doing great!")
//                        .font(.title3)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Your Reflection (optional)")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Titel")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            TextField("Write title", text: $reflectionTitle)
//                                .padding()
//                                .background(Color.black.opacity(0.3))
//                                .cornerRadius(12)
//                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))
//                                .foregroundColor(.white)
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("More details")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            ZStack(alignment: .bottomTrailing) {
//                                TextEditor(text: $reflectionDetails)
//                                    .frame(height: 100)
//                                    .scrollContentBackground(.hidden)
//                                    .padding(8)
//                                    .background(Color.black.opacity(0.3))
//                                    .cornerRadius(12)
//                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))
//                                    .foregroundColor(.white)
//                                    
//                                Text("\(reflectionDetails.count)/100")
//                                    .font(.system(size: 10))
//                                    .foregroundColor(.gray)
//                                    .padding(8)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                }
//                .padding(.vertical, 20)
//            }
//            
//            Button(action: {
//                let trimmedTitle = reflectionTitle.trimmingCharacters(in: .whitespaces)
//                if !trimmedTitle.isEmpty {
//                    viewModel.addReflection(title: trimmedTitle, content: reflectionDetails)
//                }
//                withAnimation(.spring()) { showSuccessPopup = true }
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                    withAnimation {
//                        showSuccessPopup = false
//                        dismiss()
//                    }
//                }
//            }) {
//                Text("Release")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
//                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
//            }
//            .padding(.horizontal, 40)
//            .padding(.bottom, 40)
//        }
//    }
//
//    var successPopupView: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1))
//            RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.3), lineWidth: 1.5)
//            VStack(spacing: 12) {
//                Text("It's out now").font(.system(size: 26, weight: .medium))
//                Text("Take a deep breath").font(.system(size: 30, weight: .bold))
//            }
//            .foregroundColor(.white)
//        }
//        .frame(width: 300, height: 320)
//    }
//
//    var warningView: some View {
//        HStack(alignment: .top, spacing: 8) {
//            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
//            Text("This test is for awareness purposes only and does not replace consulting specialists.").font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
//        }
//        .padding(.horizontal, 40).padding(.bottom, 30)
//    }
//
//    func nextAction() {
//        totalScore += (selectedOption ?? 0)
//        withAnimation(.interpolatingSpring(stiffness: 120, damping: 15)) {
//            if currentIdx < 5 {
//                currentIdx += 1
//                selectedOption = nil
//            } else {
//                step = 2
//            }
//        }
//    }
//}
import SwiftUI

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
    @State private var ballOpacity: Double = 0.6

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
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            if step == 0 {
                startPage
                    .transition(.opacity)
            } else if step == 1 {
                questionsPage
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                resultPage
                    .transition(.opacity)
            }
            
            if showSuccessPopup {
                Color.black.opacity(0.6)
                    .background(.ultraThinMaterial.opacity(0.8))
                    .ignoresSafeArea()
                
                successPopupView
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
                    .zIndex(1)
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
                .opacity(ballOpacity)
                .shadow(color: .black.opacity(0.4), radius: 20)

            Spacer()
            warningView

            Button(action: {
                withAnimation(.easeOut(duration: 0.2)) { ballOpacity = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { step = 1 }
                }
            }) {
                Text("Start")
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

    // MARK: - شاشة الأسئلة
    var questionsPage: some View {
        VStack {
            // الأسهم العلوية (تم توسيع المسافات وحذف زر نكست)
            HStack {
                // سهم لليسار
                Button(action: {
                    if currentIdx > 0 {
                        withAnimation { currentIdx -= 1 }
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(currentIdx > 0 ? .white : .white.opacity(0.2))
                        .padding(15) // زيادة مساحة اللمس
                }
                .disabled(currentIdx == 0)

                Spacer() // توسيع المسافة القصوى بين الأسهم

                Text("\(currentIdx + 1)/6")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Spacer() // توسيع المسافة القصوى بين الأسهم

                // سهم لليمين (ينقل للسؤال التالي)
                Button(action: {
                    if currentIdx < 5 && selectedOption != nil {
                        nextAction()
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(currentIdx < 5 && selectedOption != nil ? .white : .white.opacity(0.2))
                        .padding(15) // زيادة مساحة اللمس
                }
                .disabled(currentIdx == 5 || selectedOption == nil)
            }
            .padding(.horizontal, 40) // تضييق العرض قليلاً ليبدو متناسقاً
            .padding(.top, 30)
            
            Spacer()
            
            QuestionCard(text: questions[currentIdx].text, selected: $selectedOption)
                .id(currentIdx)
                .drawingGroup()
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            
            Spacer()
            
            // يظهر فقط في السؤال الأخير بدلاً من Next
            if currentIdx == 5 {
                Button(action: nextAction) {
                    Text("Done")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 254, height: 49)
                        .glassEffect(in:.rect(cornerRadius: 12))
                        .background(.text.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                .disabled(selectedOption == nil)
                .padding(.bottom, 30)
                .transition(.opacity)
            } else {
                // مساحة فارغة للحفاظ على التوازن البصري عند غياب الزر
                Color.clear.frame(height: 49).padding(.bottom, 30)
            }
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
                        Text("Your Reflection (optional)").font(.headline).foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title").font(.caption).foregroundColor(.gray)
                            TextField("Write title", text: $reflectionTitle)
                                .padding().background(Color.black.opacity(0.3)).cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("More details").font(.caption).foregroundColor(.gray)
                            ZStack(alignment: .bottomTrailing) {
                                TextEditor(text: $reflectionDetails)
                                    .frame(height: 100).scrollContentBackground(.hidden)
                                    .padding(8).background(Color.black.opacity(0.3)).cornerRadius(12)
                                Text("\(reflectionDetails.count)/100").font(.system(size: 10)).foregroundColor(.gray).padding(8)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
            }
            
            Button(action: {
                if !reflectionTitle.isEmpty { viewModel.addReflection(title: reflectionTitle, content: reflectionDetails) }
                withAnimation(.spring()) { showSuccessPopup = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation { showSuccessPopup = false; dismiss() }
                }
            }) {
                Text("Release")
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

//    var successPopupView: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1))
//            VStack(spacing: 12) {
//                Text("It's out now").font(.system(size: 26, weight: .medium))
//                Text("Take a deep breath").font(.system(size: 30, weight: .bold))
//            }
//            .foregroundColor(.white)
//        }
//        .frame(width: 300, height: 320)
//    }
    var successPopupView: some View {
        ZStack {
            // 1. الخلفية الأساسية (الطبقة الخارجية)
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.1))
                .background(.ultraThinMaterial)
                .cornerRadius(25)
                // الإطار الخارجي النحيف جداً
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
            
            // 2. الإطار الداخلي (الخط المزدوج اللي داخل الكارد)
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                .padding(15) // المسافة بين الإطار الخارجي والداخلي
            
            // 3. الدوائر الأربعة في الزوايا (داخل الإطار الداخلي)
            GeometryReader { geo in
                let dotSize: CGFloat = 12
                let offset: CGFloat = 35 // مكان الدوائر بالنسبة للزوايا
                
                Group {
                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize) // فوق يسار
                        .position(x: offset, y: offset)
                    
                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize) // فوق يمين
                        .position(x: geo.size.width - offset, y: offset)
                    
                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize) // تحت يسار
                        .position(x: offset, y: geo.size.height - offset)
                    
                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize) // تحت يمين
                        .position(x: geo.size.width - offset, y: geo.size.height - offset)
                }
            }
            
            // 4. النصوص في المنتصف
            VStack(spacing: 12) {
                Text("It's out now")
                    .font(.system(size: 26, weight: .medium))
                
                Text("Take a deep breath")
                    .font(.system(size: 30, weight: .bold))
                    .multilineTextAlignment(.center)
            }
            .padding(40)
            .foregroundColor(.white)
        }
        .frame(width: 320, height: 350) // تكبير الحجم قليلاً ليتناسب مع التفاصيل
    }
    var warningView: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
            Text("This test is for awareness purposes only and does not replace consulting specialists.").font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 40).padding(.bottom, 30)
    }

    func nextAction() {
        totalScore += (selectedOption ?? 0)
        withAnimation(.interpolatingSpring(stiffness: 120, damping: 15)) {
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
    BurnoutCheckView(viewModel: TestViewModel())
}
