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
//            .padding(.top, 10)
//
//            Spacer()
//            Text("We’ll ask you a few quick questions to understand your burnout level")
//                .font(.system(size: 20, weight: .medium))
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 30)
//
//            Spacer()
//            VideoLoopPlayer(fileName: "Ball2")
//                .frame(width: 220, height: 220)
//                .clipShape(Circle())
//                .grayscale(1.0)
//                .opacity(ballOpacity)
//                .shadow(color: .black.opacity(0.4), radius: 20)
//
//            Spacer()
//            warningView
//
//            Button(action: {
//                withAnimation(.easeOut(duration: 0.2)) { ballOpacity = 0 }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { step = 1 }
//                }
//            }) {
//                Text("Start")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//            }
//            .padding(.bottom, 40)
//        }
//    }
//
//    // MARK: - شاشة الأسئلة
//    var questionsPage: some View {
//        VStack {
//            // الأسهم العلوية (تم توسيع المسافات وحذف زر نكست)
//            HStack {
//                // سهم لليسار
//                Button(action: {
//                    if currentIdx > 0 {
//                        withAnimation { currentIdx -= 1 }
//                    }
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 22, weight: .bold))
//                        .foregroundColor(currentIdx > 0 ? .white : .white.opacity(0.2))
//                        .padding(15) // زيادة مساحة اللمس
//                }
//                .disabled(currentIdx == 0)
//
//                Spacer() // توسيع المسافة القصوى بين الأسهم
//
//                Text("\(currentIdx + 1)/6")
//                    .font(.system(size: 22, weight: .bold))
//                    .foregroundColor(.white)
//
//                Spacer() // توسيع المسافة القصوى بين الأسهم
//
//                // سهم لليمين (ينقل للسؤال التالي)
//                Button(action: {
//                    if currentIdx < 5 && selectedOption != nil {
//                        nextAction()
//                    }
//                }) {
//                    Image(systemName: "chevron.right")
//                        .font(.system(size: 22, weight: .bold))
//                        .foregroundColor(currentIdx < 5 && selectedOption != nil ? .white : .white.opacity(0.2))
//                        .padding(15) // زيادة مساحة اللمس
//                }
//                .disabled(currentIdx == 5 || selectedOption == nil)
//            }
//            .padding(.horizontal, 40) // تضييق العرض قليلاً ليبدو متناسقاً
//            .padding(.top, 30)
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
//            // يظهر فقط في السؤال الأخير بدلاً من Next
//            if currentIdx == 5 {
//                Button(action: nextAction) {
//                    Text("Done")
//                        .font(.system(size: 20, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(width: 254, height: 49)
//                        .glassEffect(in:.rect(cornerRadius: 12))
//                        .background(.text.opacity(0.3))
//                        .cornerRadius(12)
//                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
//                }
//                .disabled(selectedOption == nil)
//                .padding(.bottom, 30)
//                .transition(.opacity)
//            } else {
//                // مساحة فارغة للحفاظ على التوازن البصري عند غياب الزر
//                Color.clear.frame(height: 49).padding(.bottom, 30)
//            }
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
//                        .colorMultiply(totalScore > 12 ? .redApp : .green)
//                        
//                    Text(totalScore > 12 ? "We noticed early signs of burnout,Take care of yourself today" : "You're doing great!")
//                        .font(.title3)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Your Reflection (optional)").font(.headline).foregroundColor(.white)
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Title").font(.caption).foregroundColor(.gray)
//                            TextField("Write title", text: $reflectionTitle)
//                                .padding().background(Color.black.opacity(0.3)).cornerRadius(12)
//                                .foregroundColor(.white)
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("More details").font(.caption).foregroundColor(.gray)
//                            ZStack(alignment: .bottomTrailing) {
//                                TextEditor(text: $reflectionDetails)
//                                    .frame(height: 100).scrollContentBackground(.hidden)
//                                    .padding(8).background(Color.black.opacity(0.3)).cornerRadius(12)
//                                Text("\(reflectionDetails.count)/100").font(.system(size: 10)).foregroundColor(.gray).padding(8)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                }
//                .padding(.vertical, 20)
//            }
//            
//            Button(action: {
//                if !reflectionTitle.isEmpty { viewModel.addReflection(title: reflectionTitle, content: reflectionDetails) }
//                withAnimation(.spring()) { showSuccessPopup = true }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    withAnimation { showSuccessPopup = false; dismiss() }
//                }
//            }) {
//                Text("Release")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//            }
//            .padding(.bottom, 40)
//        }
//    }
//
////    var successPopupView: some View {
////        ZStack {
////            RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1))
////            VStack(spacing: 12) {
////                Text("It's out now").font(.system(size: 26, weight: .medium))
////                Text("Take a deep breath").font(.system(size: 30, weight: .bold))
////            }
////            .foregroundColor(.white)
////        }
////        .frame(width: 300, height: 320)
////    }
//    var successPopupView: some View {
//        ZStack {
//            // 1. الخلفية الأساسية (الطبقة الخارجية)
//            RoundedRectangle(cornerRadius: 25)
//                .fill(Color.white.opacity(0.1))
//                .background(.ultraThinMaterial)
//                .cornerRadius(25)
//                // الإطار الخارجي النحيف جداً
//                .overlay(
//                    RoundedRectangle(cornerRadius: 25)
//                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
//                )
//            
//            // 2. الإطار الداخلي (الخط المزدوج اللي داخل الكارد)
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                .padding(15) // المسافة بين الإطار الخارجي والداخلي
//            
//            // 3. الدوائر الأربعة في الزوايا (داخل الإطار الداخلي)
//            GeometryReader { geo in
//                let dotSize: CGFloat = 12
//                let offset: CGFloat = 35 // مكان الدوائر بالنسبة للزوايا
//                
//                Group {
//                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize) // فوق يسار
//                        .position(x: offset, y: offset)
//                    
//                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize) // فوق يمين
//                        .position(x: geo.size.width - offset, y: offset)
//                    
//                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize) // تحت يسار
//                        .position(x: offset, y: geo.size.height - offset)
//                    
//                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize) // تحت يمين
//                        .position(x: geo.size.width - offset, y: geo.size.height - offset)
//                }
//            }
//            
//            // 4. النصوص في المنتصف
//            VStack(spacing: 12) {
//                Text("It's out now")
//                    .font(.system(size: 26, weight: .medium))
//                
//                Text("Take a deep breath")
//                    .font(.system(size: 30, weight: .bold))
//                    .multilineTextAlignment(.center)
//            }
//            .padding(40)
//            .foregroundColor(.white)
//        }
//        .frame(width: 320, height: 350) // تكبير الحجم قليلاً ليتناسب مع التفاصيل
//    }
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
//#Preview {
//    BurnoutCheckView(viewModel: TestViewModel())
//}
//import SwiftUI
//
//struct Question {
//    let text: String
//    let category: String
//}
//
//struct BurnoutCheckView: View {
//    @State private var isMovingBack = false
//    @ObservedObject var viewModel: TestViewModel
//    @Environment(\.dismiss) var dismiss
//    @State private var step = 0
//    @State private var currentIdx = 0
//    
//    // مصفوفة لتخزين الإجابات (nil تعني لم يتم الإجابة بعد)
//    @State private var answers: [Int?] = Array(repeating: nil, count: 6)
//    
//    @State private var reflectionTitle: String = ""
//    @State private var reflectionDetails: String = ""
//    
//    @State private var showSuccessPopup = false
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
//    // حساب المجموع الكلي بناءً على القيم المحفوظة في المصفوفة
//    var totalScore: Int {
//        answers.compactMap { $0 }.reduce(0, +)
//    }
//    
//    var body: some View {
//        ZStack {
//            Image("Background")
//                .resizable()
//                .ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                headerView
//                
//                if step == 0 {
//                    startPage
//                        .transition(.opacity)
//                } else if step == 1 {
//                    questionsPage
//                } else {
//                    resultPage
//                        .transition(.opacity)
//                }
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
//        }
//        .navigationBarBackButtonHidden(true)
//        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: step)
//        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentIdx)
//    }
//    
//    // MARK: - الأجزاء الفرعية (Sub-views)
//    
//    var headerView: some View {
//        ZStack {
//            HStack {
//                Button(action: {
//                    if step == 1 {
//                        if currentIdx > 0 {
//                            isMovingBack = true
//                            withAnimation(.easeInOut(duration: 0.6)) {
//                                currentIdx -= 1
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                                isMovingBack = false
//                            }
//                        } else {
//                            withAnimation { step = 0 }
//                        }
//                    } else if step > 0 {
//                        withAnimation { step -= 1 }
//                    } else {
//                        dismiss()
//                    }
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundColor(.white)
//                        .padding(.leading, 20)
//                }
//                Spacer()
//            }
//            Text("Burnout Check")
//                .font(.system(size: 22, weight: .bold))
//                .foregroundColor(.white)
//        }
//        .frame(height: 44)
//        .padding(.top, 10)
//    }
//    
//    var startPage: some View {
//        VStack {
//            Spacer()
//            Text("We’ll ask you a few quick questions to understand your burnout level")
//                .font(.system(size: 20, weight: .medium))
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 30)
//            
//            Spacer()
//            VideoLoopPlayer(fileName: "Ball2")
//                .frame(width: 220, height: 220)
//                .clipShape(Circle())
//                .grayscale(1.0)
//                .opacity(ballOpacity)
//                .shadow(color: .black.opacity(0.4), radius: 20)
//            
//            Spacer()
//            warningView
//            
//            Button(action: {
//                withAnimation(.easeOut(duration: 0.2)) { ballOpacity = 0 }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                    step = 1
//                }
//            }) {
//                Text("Start")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//                                                    }
//                .padding(.bottom, 40)
//                                                }
//                                            }
//    
//    var questionsPage: some View {
//        VStack {
//            Text("\(currentIdx + 1)/\(questions.count)")
//                .font(.system(size: 18, weight: .semibold))
//                .foregroundColor(.white.opacity(0.6))
//                .padding(.top, 20)
//            
//            Spacer()
//            
//            QuestionCard(text: questions[currentIdx].text, selected: $answers[currentIdx])
//                .id(currentIdx)
//                .transition(.asymmetric(
//                    insertion: .move(edge: .trailing).combined(with: .opacity),
//                    removal: .move(edge: .leading).combined(with: .opacity)
//                ))
//                .onChange(of: answers[currentIdx]) { newValue in
//                    if newValue != nil && currentIdx < questions.count - 1 && !isMovingBack {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                            if !isMovingBack {
//                                withAnimation(.easeInOut(duration: 0.6)) {
//                                    currentIdx += 1
//                                }
//                            }
//                        }
//                    }
//                }
//            
//            Spacer()
//            
//            if currentIdx == questions.count - 1 && answers[currentIdx] != nil {
//                Button(action: {
//                    withAnimation { step = 2 }
//                })
//                {
//                    Text("Done")
//                        .font(.system(size: 20, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(width: 254, height: 49)
//                        .glassEffect(in:.rect(cornerRadius: 12))
//                        .background(Color.white.opacity(0.3))
//                        .cornerRadius(12)
//                }
//                
//                .padding(.bottom, 40)
//            }
//            else {
//                Color.clear.frame(height: 49).padding(.bottom, 40)
//            }
//        }
//    }
//    
//    var resultPage: some View {
//        VStack(spacing: 0) {
//            ScrollView {
//                VStack(spacing: 25) {
//                    VideoLoopPlayer(fileName: "Ball2")
//                        .frame(width: 200, height: 200)
//                        .clipShape(Circle())
//                        .colorMultiply(totalScore > 12 ? .red : .green)
//                    
//                    Text(totalScore > 12 ? "We noticed early signs of burnout. Take care of yourself today." : "You're doing great!")
//                        .font(.title3)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Your Reflection (optional)").font(.headline).foregroundColor(.white)
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Title").font(.caption).foregroundColor(.gray)
//                            TextField("Write title", text: $reflectionTitle)
//                                .padding().background(Color.black.opacity(0.3)).cornerRadius(12)
//                                .foregroundColor(.white)
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("More details").font(.caption).foregroundColor(.gray)
//                            ZStack(alignment: .bottomTrailing) {
//                                TextEditor(text: $reflectionDetails)
//                                    .frame(height: 100).scrollContentBackground(.hidden)
//                                    .padding(8).background(Color.black.opacity(0.3)).cornerRadius(12)
//                                Text("\(reflectionDetails.count)/100").font(.system(size: 10)).foregroundColor(.gray).padding(8)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                }
//                .padding(.vertical, 20)
//            }
//            
//            Button(action: {
//                if !reflectionTitle.isEmpty {
//                    viewModel.addReflection(title: reflectionTitle, content: reflectionDetails)
//                }
//                withAnimation(.spring()) { showSuccessPopup = true }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    withAnimation {
//                        showSuccessPopup = false
//                        dismiss()
//                    }
//                }
//            }) {
//                Text("Release")
//                    .font(.system(size: 20, weight: .bold))
//                                                            .foregroundColor(.white)
//                                                            .frame(width: 254, height: 49)
//                                                            .glassEffect(in:.rect(cornerRadius: 12))
//                                                            .background(.text.opacity(0.3))
//                                                            .cornerRadius(12)
//                                                    }
//                                                    .padding(.bottom, 40)
//                                                }
//                                            }
//    
//    var successPopupView: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 25)
//                .fill(Color.white.opacity(0.1))
//                .background(.ultraThinMaterial)
//                .cornerRadius(25)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 25)
//                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
//                )
//            
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                .padding(15)
//            
//            GeometryReader { geo in
//                let dotSize: CGFloat = 12
//                let offset: CGFloat = 35
//                Group {
//                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize).position(x: offset, y: offset)
//                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize).position(x: geo.size.width - offset, y: offset)
//                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize).position(x: offset, y: geo.size.height - offset)
//                    Circle().fill(Color.white.opacity(0.4)).frame(width: dotSize).position(x: geo.size.width - offset, y: geo.size.height - offset)
//                }
//            }
//            
//            VStack(spacing: 12) {
//                Text("It's out now").font(.system(size: 26, weight: .medium))
//                Text("Take a deep breath").font(.system(size: 30, weight: .bold)).multilineTextAlignment(.center)
//            }
//            .padding(40)
//            .foregroundColor(.white)
//        }
//        .frame(width: 320, height: 350)
//    }
//    
//    var warningView: some View {
//        HStack(alignment: .top, spacing: 8) {
//            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
//            Text("This test is for awareness purposes only and does not replace consulting specialists.").font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
//        }
//        .padding(.horizontal, 40).padding(.bottom, 30)
//    }
//}
//
//#Preview {
//    BurnoutCheckView(viewModel: TestViewModel())
//}
//import SwiftUI
//
//struct Question {
//    let text: String
//    let category: String
//}
//
//struct BurnoutCheckView: View {
//    @State private var isMovingBack = false
//    @ObservedObject var viewModel: TestViewModel
//    @Environment(\.dismiss) var dismiss
//    @State private var step = 0
//    @State private var currentIdx = 0
//    
//    // مصفوفة لتخزين الإجابات (nil تعني لم يتم الإجابة بعد)
//    @State private var answers: [Int?] = Array(repeating: nil, count: 6)
//    
//    @State private var reflectionTitle: String = ""
//    @State private var reflectionDetails: String = ""
//    
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
//    // حساب المجموع الكلي بناءً على القيم المحفوظة في المصفوفة
//    var totalScore: Int {
//        answers.compactMap { $0 }.reduce(0, +)
//    }
//    
//    var body: some View {
//        ZStack {
//            Image("Background")
//                .resizable()
//                .ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                headerView
//                
//                if step == 0 {
//                    startPage
//                        .transition(.opacity)
//                } else if step == 1 {
//                    questionsPage
//                } else {
//                    resultPage
//                        .transition(.opacity)
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: step)
//        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentIdx)
//    }
//    
//    // MARK: - الأجزاء الفرعية (Sub-views)
//    
//    var headerView: some View {
//        ZStack {
//            HStack {
//                Button(action: {
//                    if step == 1 {
//                        if currentIdx > 0 {
//                            isMovingBack = true
//                            withAnimation(.easeInOut(duration: 0.6)) {
//                                currentIdx -= 1
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                                isMovingBack = false
//                            }
//                        } else {
//                            withAnimation { step = 0 }
//                        }
//                    } else if step > 0 {
//                        withAnimation { step -= 1 }
//                    } else {
//                        dismiss()
//                    }
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundColor(.white)
//                        .padding(.leading, 20)
//                }
//                Spacer()
//            }
//            Text("Burnout Check")
//                .font(.system(size: 22, weight: .bold))
//                .foregroundColor(.white)
//        }
//        .frame(height: 44)
//        .padding(.top, 10)
//    }
//    
//    var startPage: some View {
//        VStack {
//            Spacer()
//            Text("We’ll ask you a few quick questions to understand your burnout level")
//                .font(.system(size: 20, weight: .medium))
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 30)
//            
//            Spacer()
//            VideoLoopPlayer(fileName: "Ball2")
//                .frame(width: 220, height: 220)
//                .clipShape(Circle())
//                .grayscale(1.0)
//                .opacity(ballOpacity)
//                .shadow(color: .black.opacity(0.4), radius: 20)
//            
//            Spacer()
//            warningView
//            
//            Button(action: {
//                withAnimation(.easeOut(duration: 0.2)) { ballOpacity = 0 }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                    step = 1
//                }
//            }) {
//                Text("Start")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(Color.white.opacity(0.3))
//                    .cornerRadius(12)
//            }
//            .padding(.bottom, 40)
//        }
//    }
//    
//    var questionsPage: some View {
//        VStack {
//            Text("\(currentIdx + 1)/\(questions.count)")
//                .font(.system(size: 18, weight: .semibold))
//                .foregroundColor(.white.opacity(0.6))
//                .padding(.top, 20)
//            
//            Spacer()
//            
//            QuestionCard(text: questions[currentIdx].text, selected: $answers[currentIdx])
//                .id(currentIdx)
//                .transition(.asymmetric(
//                    insertion: .move(edge: .trailing).combined(with: .opacity),
//                    removal: .move(edge: .leading).combined(with: .opacity)
//                ))
//                .onChange(of: answers[currentIdx]) { newValue in
//                    if newValue != nil && currentIdx < questions.count - 1 && !isMovingBack {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                            if !isMovingBack {
//                                withAnimation(.easeInOut(duration: 0.6)) {
//                                    currentIdx += 1
//                                }
//                            }
//                        }
//                    }
//                }
//            
//            Spacer()
//            
//            if currentIdx == questions.count - 1 && answers[currentIdx] != nil {
//                Button(action: {
//                    withAnimation { step = 2 }
//                })
//                {
//                    Text("Done")
//                        .font(.system(size: 20, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(width: 254, height: 49)
//                        .glassEffect(in:.rect(cornerRadius: 12))
//                        .background(Color.white.opacity(0.3))
//                        .cornerRadius(12)
//                }
//                .padding(.bottom, 40)
//            }
//            else {
//                Color.clear.frame(height: 49).padding(.bottom, 40)
//            }
//        }
//    }
//    
//    var resultPage: some View {
//        VStack(spacing: 0) {
//            ScrollView {
//                VStack(spacing: 25) {
//                    VideoLoopPlayer(fileName: "Ball2")
//                        .frame(width: 200, height: 200)
//                        .clipShape(Circle())
//                        .colorMultiply(totalScore > 12 ? .red : .green)
//                    
//                    Text(totalScore > 12 ? "We noticed early signs of burnout. Take care of yourself today." : "You're doing great!")
//                        .font(.title3)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Your Reflection (optional)").font(.headline).foregroundColor(.white)
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Title").font(.caption).foregroundColor(.gray)
//                            TextField("Write title", text: $reflectionTitle)
//                                .padding().background(Color.black.opacity(0.3)).cornerRadius(12)
//                                .foregroundColor(.white)
//                        }
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("More details").font(.caption).foregroundColor(.gray)
//                            ZStack(alignment: .bottomTrailing) {
//                                TextEditor(text: $reflectionDetails)
//                                    .frame(height: 100).scrollContentBackground(.hidden)
//                                    .padding(8).background(Color.black.opacity(0.3)).cornerRadius(12)
//                                Text("\(reflectionDetails.count)/100").font(.system(size: 10)).foregroundColor(.gray).padding(8)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                }
//                .padding(.vertical, 20)
//            }
//            
//            Button(action: {
//                if !reflectionTitle.isEmpty {
//                    viewModel.addReflection(title: reflectionTitle, content: reflectionDetails)
//                }
//                // الحذف تم هنا: الصفحة تغلق مباشرة عند الضغط
//                withAnimation {
//                    dismiss()
//                }
//            }) {
//                Text("Release")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(Color.white.opacity(0.3))
//                    .cornerRadius(12)
//            }
//            .padding(.bottom, 40)
//        }
//    }
//    
//    var warningView: some View {
//        HStack(alignment: .top, spacing: 8) {
//            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
//            Text("This test is for awareness purposes only and does not replace consulting specialists.").font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
//        }
//        .padding(.horizontal, 40).padding(.bottom, 30)
//    }
//}
//
//#Preview {
//    BurnoutCheckView(viewModel: TestViewModel())
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
//    
//    @State private var step = 0 // 0: Start, 1: Questions, 2: Result, 3: Reflection
//    @State private var currentIdx = 0
//    @State private var isMovingBack = false
//    @State private var answers: [Int?] = Array(repeating: nil, count: 6)
//    
//    @State private var reflectionTitle: String = ""
//    @State private var reflectionDetails: String = ""
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
//    var totalScore: Int {
//        answers.compactMap { $0 }.reduce(0, +)
//    }
//    
//    var body: some View {
//        ZStack {
//            Image("Background")
//                .resizable()
//                .ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                if step != 3 { headerView } // الهيدر العادي يختفي في صفحة الرفلكشن
//                
//                switch step {
//                case 0:
//                    startPage.transition(.opacity)
//                case 1:
//                    questionsPage
//                case 2:
//                    resultPage.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
//                case 3:
//                    reflectionPage.transition(.move(edge: .bottom))
//                default:
//                    EmptyView()
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: step)
//    }
//    
//    // MARK: - Header
//    var headerView: some View {
//        ZStack {
//            HStack {
//                Button(action: {
//                    if step == 1 && currentIdx > 0 {
//                        withAnimation { currentIdx -= 1 }
//                    } else if step > 0 {
//                        withAnimation { step -= 1 }
//                    } else {
//                        dismiss()
//                    }
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundColor(.white)
//                        .padding(.leading, 20)
//                }
//                Spacer()
//            }
//            Text(step == 2 ? "Burnout check Result" : "Burnout Check")
//                .font(.system(size: 22, weight: .bold))
//                .foregroundColor(.white)
//        }
//        .frame(height: 44).padding(.top, 10)
//    }
//
//    // MARK: - 1. Start Page
//    var startPage: some View {
//        VStack {
//            Spacer()
//            Text("We’ll ask you a few quick questions to understand your burnout level")
//                .font(.system(size: 20, weight: .medium)).foregroundColor(.white)
//                .multilineTextAlignment(.center).padding(.horizontal, 30)
//            Spacer()
//            VideoLoopPlayer(fileName: "Ball2")
//                .frame(width: 220, height: 220).clipShape(Circle())
//                .grayscale(1.0).opacity(ballOpacity)
//            Spacer()
//            warningView
//            Button(action: { withAnimation { step = 1 } }) {
//                Text("Start").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
//                    .frame(width: 254, height: 49).background(Color.white.opacity(0.2)).cornerRadius(12)
//            }.padding(.bottom, 40)
//        }
//    }
//
//    // MARK: - 2. Questions Page (نفس كودك السابق مع تبسيط)
//    var questionsPage: some View {
//        VStack {
//            Text("\(currentIdx + 1)/\(questions.count)").foregroundColor(.white.opacity(0.6)).padding(.top, 20)
//            Spacer()
//            QuestionCard(text: questions[currentIdx].text, selected: $answers[currentIdx])
//                .id(currentIdx)
//                .onChange(of: answers[currentIdx]) { newValue in
//                    if newValue != nil && currentIdx < questions.count - 1 {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                            withAnimation { currentIdx += 1 }
//                        }
//                    }
//                }
//            Spacer()
//            if currentIdx == questions.count - 1 && answers[currentIdx] != nil {
//                Button("Done") { withAnimation { step = 2 } }
//                    .font(.system(size: 20, weight: .bold)).foregroundColor(.white)
//                    .frame(width: 254, height: 49).background(Color.white.opacity(0.2)).cornerRadius(12)
//                    .padding(.bottom, 40)
//            }
//        }
//    }
//
//    // MARK: - 3. Result Page (الشاشة اليسار في الصورة)
//    var resultPage: some View {
//        VStack(spacing: 40) {
//            Spacer()
//            VideoLoopPlayer(fileName: "Ball2")
//                .frame(width: 240, height: 240).clipShape(Circle())
//                .colorMultiply(totalScore > 12 ? .red : .green)
//            
//            Text("Based on your answers you may be showing early signs of burnout\nMake sure to take care of yourself today")
//                .font(.system(size: 18, weight: .medium)).foregroundColor(.white)
//                .multilineTextAlignment(.center).padding(.horizontal, 40)
//            
//            Spacer()
//            
//            Button(action: { withAnimation { step = 3 } }) {
//                Text("Done").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
//                    .frame(width: 254, height: 49).background(Color.white.opacity(0.2)).cornerRadius(12)
//            }.padding(.bottom, 40)
//        }
//    }
//
//    // MARK: - 4. Reflection Page (الشاشة اليمين في الصورة)
//    var reflectionPage: some View {
//        VStack(spacing: 25) {
//            // Custom Navigation for Reflection
//            HStack {
//                Button(action: { withAnimation { step = 2 } }) {
//                    Image(systemName: "xmark").circleBackground()
//                }
//                Spacer()
//                Text("Reflection").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
//                Spacer()
//                Button(action: {
//                    if !reflectionTitle.isEmpty { viewModel.addReflection(title: reflectionTitle, content: reflectionDetails) }
//                    dismiss()
//                }) {
//                    Image(systemName: "checkmark").circleBackground()
//                }
//            }
//            .padding(.horizontal, 20).padding(.top, 10)
//
//            VStack(alignment: .leading, spacing: 30) {
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Write your reflection (Optional)").font(.title2.bold()).foregroundColor(.white)
//                    
//                    Text("Give it a name").foregroundColor(.white.opacity(0.9))
//                    TextField("Label this moment..", text: $reflectionTitle)
//                        .padding().background(Color.white.opacity(0.1)).cornerRadius(12).foregroundColor(.white)
//                }
//
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Express your thoughts").foregroundColor(.white.opacity(0.9))
//                    ZStack(alignment: .bottomTrailing) {
//                        TextEditor(text: $reflectionDetails)
//                            .frame(height: 150).scrollContentBackground(.hidden)
//                            .padding(10).background(Color.white.opacity(0.1)).cornerRadius(12)
//                        Text("\(reflectionDetails.count)/100").font(.caption).foregroundColor(.gray).padding(10)
//                    }
//                }
//            }
//            .padding(.horizontal, 25)
//            Spacer()
//        }
//    }
//
//    var warningView: some View {
//        HStack(alignment: .top, spacing: 8) {
//            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
//            Text("This test is for awareness purposes only and does not replace consulting specialists.").font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
//        }.padding(.horizontal, 40).padding(.bottom, 30)
//    }
//}
//
//// Helper لعمل الأزرار الدائرية في الهيدر
//extension View {
//    func circleBackground() -> some View {
//        self.font(.system(size: 16, weight: .bold))
//            .foregroundColor(.white)
//            .frame(width: 40, height: 40)
//            .background(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
//    }
//}
//#Preview {
//    BurnoutCheckView(viewModel: TestViewModel())
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
//    
//    @State private var step = 0 // 0: Start, 1: Questions, 2: Result, 3: Reflection
//    @State private var currentIdx = 0
//    @State private var isMovingBack = false
//    @State private var answers: [Int?] = Array(repeating: nil, count: 6)
//    
//    @State private var reflectionTitle: String = ""
//    @State private var reflectionDetails: String = ""
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
//    var totalScore: Int {
//        answers.compactMap { $0 }.reduce(0, +)
//    }
//    
//    var body: some View {
//        ZStack {
//            Image("Background")
//                .resizable()
//                .ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                if step != 3 { headerView }
//                
//                switch step {
//                case 0:
//                    startPage.transition(.opacity)
//                case 1:
//                    questionsPage
//                case 2:
//                    resultPage.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
//                case 3:
//                    reflectionPage.transition(.move(edge: .bottom))
//                default:
//                    EmptyView()
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: step)
//        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentIdx)
//    }
//    
//    // MARK: - Header
//    var headerView: some View {
//        ZStack {
//            HStack {
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
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundColor(.white)
//                        .padding(.leading, 20)
//                }
//                Spacer()
//            }
//            Text(step == 2 ? "Burnout check Result" : "Burnout Check")
//                .font(.system(size: 22, weight: .bold))
//                .foregroundColor(.white)
//        }
//        .frame(height: 44).padding(.top, 10)
//    }
//
//    // MARK: - 1. Start Page
//    var startPage: some View {
//        VStack {
//            Spacer()
//            Text("We’ll ask you a few quick questions to understand your burnout level")
//                .font(.system(size: 20, weight: .medium)).foregroundColor(.white)
//                .multilineTextAlignment(.center).padding(.horizontal, 30)
//            Spacer()
//            VideoLoopPlayer(fileName: "Ball2")
//                .frame(width: 220, height: 220).clipShape(Circle())
//                .grayscale(1.0).opacity(ballOpacity)
//            Spacer()
//            warningView
//            Button(action: { withAnimation { step = 1 } }) {
//                Text("Start")
//                                    .font(.system(size: 20, weight: .bold))
//                                    .foregroundColor(.white)
//                                    .frame(width: 254, height: 49)
//                                    .glassEffect(in:.rect(cornerRadius: 12))
//                                    .background(.text.opacity(0.3))
//                                    .cornerRadius(12)
//                                                                    }
//                                .padding(.bottom, 40)
//                                                                }
//                                                            }
//                    
//
//    // MARK: - 2. Questions Page
//    var questionsPage: some View {
//        VStack {
//            Text("\(currentIdx + 1)/\(questions.count)").foregroundColor(.white.opacity(0.6)).padding(.top, 20)
//            Spacer()
//            
//            //  (Asymmetric Transition)
//            QuestionCard(text: questions[currentIdx].text, selected: $answers[currentIdx])
//                .id(currentIdx)
//                .transition(.asymmetric(
//                    insertion: .move(edge: .trailing).combined(with: .opacity),
//                    removal: .move(edge: .leading).combined(with: .opacity)
//                ))
//                .onChange(of: answers[currentIdx]) { newValue in
//                    guard newValue != nil && !isMovingBack else { return }
//                    
//                    // إذا كان هذا آخر سؤال، ننتقل للنتيجة تلقائياً
//                    if currentIdx == questions.count - 1 {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                            withAnimation { step = 2 }
//                        }
//                    } else {
//                        // الانتقال للسؤال التالي
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                            if !isMovingBack {
//                                withAnimation(.easeInOut(duration: 0.6)) { currentIdx += 1 }
//                            }
//                        }
//                    }
//                }
//            Spacer()
//            // تم حذف زر "Done" هنا للانتقال التلقائي
//            Color.clear.frame(height: 49).padding(.bottom, 40)
//        }
//    }
//
//    // MARK: - 3. Result Page
//    var resultPage: some View {
//        VStack(spacing: 40) {
//            Spacer()
//            VideoLoopPlayer(fileName: "Ball2")
//                .frame(width: 240, height: 240).clipShape(Circle())
//                .colorMultiply(totalScore > 12 ? .red : .green)
//            
//            Text("Based on your answers you may be showing early signs of burnout\nMake sure to take care of yourself today")
//                .font(.system(size: 18, weight: .medium)).foregroundColor(.white)
//                .multilineTextAlignment(.center).padding(.horizontal, 40)
//            
//            Spacer()
//            
//            Button(action: { withAnimation { step = 3 } }) {
//                Text("Done")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(.text.opacity(0.3))
//                    .cornerRadius(12)
//                                                    }
//                .padding(.bottom, 40)
//                                                }
//                                            }
//
//
//    // MARK: - 4. Reflection Page
//    var reflectionPage: some View {
//        VStack(spacing: 25) {
//            HStack {
//                Button(action: { withAnimation { step = 2 } }) {
//                    Image(systemName: "xmark").circleBackground()
//                }
//                Spacer()
//                Text("Reflection").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
//                Spacer()
//                Button(action: {
//                    if !reflectionTitle.isEmpty { viewModel.addReflection(title: reflectionTitle, content: reflectionDetails) }
//                    dismiss()
//                }) {
//                    Image(systemName: "checkmark").circleBackground()
//                }
//            }
//            .padding(.horizontal, 20).padding(.top, 10)
//
//            VStack(alignment: .leading, spacing: 30) {
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Write your reflection (Optional)").font(.title2.bold()).foregroundColor(.white)
//                    Text("Give it a name").foregroundColor(.white.opacity(0.9))
//                    TextField("Label this moment..", text: $reflectionTitle)
//                        .padding().background(Color.white.opacity(0.1)).cornerRadius(12).foregroundColor(.white)
//                }
//
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Express your thoughts").foregroundColor(.white.opacity(0.9))
//                    ZStack(alignment: .bottomTrailing) {
//                        TextEditor(text: $reflectionDetails)
//                            .frame(height: 150).scrollContentBackground(.hidden)
//                            .padding(10).background(Color.white.opacity(0.1)).cornerRadius(12)
//                        Text("\(reflectionDetails.count)/100").font(.caption).foregroundColor(.gray).padding(10)
//                    }
//                }
//            }
//            .padding(.horizontal, 25)
//            Spacer()
//        }
//    }
//
//    var warningView: some View {
//        HStack(alignment: .top, spacing: 8) {
//            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
//            Text("This test is for awareness purposes only and does not replace consulting specialists.").font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
//        }.padding(.horizontal, 40).padding(.bottom, 30)
//    }
//}
//
//extension View {
//    func circleBackground() -> some View {
//        self.font(.system(size: 16, weight: .bold))
//            .foregroundColor(.white)
//            .frame(width: 40, height: 40)
//            .background(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
//    }
//}
//#Preview {
//    BurnoutCheckView(viewModel: TestViewModel())
//}
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
    
    // نصوص ديناميكية بناءً على النتيجة
    var resultTitle: String {
        totalScore > 12 ? "Take a deep breath" : "You're doing great!"
    }
    
    var resultMessage: String {
        totalScore > 12 ?
        "Based on your answers you may be showing early signs of burnout. Make sure to take care of yourself today." :
        "You have a healthy balance right now. Keep practicing your daily habits to stay energized!"
    }
    
    var resultButtonText: String {
        totalScore > 12 ? "Done" : "Done "
        
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
        }
        .navigationBarBackButtonHidden(true)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: step)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentIdx)
    }
    
    // MARK: - Header
    var headerView: some View {
        ZStack {
            HStack {
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
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                }
                Spacer()
            }
            Text(step == 2 ? "Burnout check Result" : "Burnout Check")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(height: 44).padding(.top, 10)
    }

    // MARK: - 1. Start Page
    var startPage: some View {
        VStack {
            Spacer()
            Text("We’ll ask you a few quick questions to understand your burnout level")
                .font(.system(size: 20, weight: .medium)).foregroundColor(.white)
                .multilineTextAlignment(.center).padding(.horizontal, 30)
            Spacer()
            VideoLoopPlayer(fileName: "Ball2")
                .frame(width: 220, height: 220).clipShape(Circle())
                .grayscale(1.0).opacity(ballOpacity)
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
                                                                                        }
                                                    .padding(.bottom, 40)
                                                                                    }
                                                                                }

    // MARK: - 2. Questions Page
    var questionsPage: some View {
        VStack {
            Text("\(currentIdx + 1)/\(questions.count)").foregroundColor(.white.opacity(0.6)).padding(.top, 20)
            Spacer()
            
            QuestionCard(text: questions[currentIdx].text, selected: $answers[currentIdx])
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
                Text(resultTitle)
                    .font(.system(size: 26, weight: .bold)).foregroundColor(.white)
                
                Text(resultMessage)
                    .font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                    .multilineTextAlignment(.center).padding(.horizontal, 40)
            }
            
            Spacer()
            
            Button(action: { withAnimation { step = 3 } }) {
                Text(resultButtonText)
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
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 254, height: 49)
//                    .glassEffect(in:.rect(cornerRadius: 12))
//                    .background(Color.white.opacity(0.3))
//                    .cornerRadius(12)
//            }
//            .padding(.bottom, 40)
//        }
//    }

    // MARK: - 4. Reflection Page
    var reflectionPage: some View {
        VStack(spacing: 25) {
            HStack {
                Button(action: { withAnimation { step = 2 } }) {
                    Image(systemName: "xmark").circleBackground()
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

            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Write your reflection (Optional)").font(.title2.bold()).foregroundColor(.white)
                    Text("Give it a name").foregroundColor(.white.opacity(0.9))
                    TextField("Label this moment..", text: $reflectionTitle)
                        .padding().background(Color.white.opacity(0.1)).cornerRadius(12).foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Express your thoughts").foregroundColor(.white.opacity(0.9))
                    ZStack(alignment: .bottomTrailing) {
                        TextEditor(text: $reflectionDetails)
                            .frame(height: 150).scrollContentBackground(.hidden)
                            .padding(10).background(Color.white.opacity(0.1)).cornerRadius(12)
                        Text("\(reflectionDetails.count)/100").font(.caption).foregroundColor(.gray).padding(10)
                    }
                }
            }
            .padding(.horizontal, 25)
            Spacer()
        }
    }

    var warningView: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
            Text("This test is for awareness purposes only and does not replace consulting specialists.").font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
        }.padding(.horizontal, 40).padding(.bottom, 30)
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
