//
//  TestView.swift
//  BurnexApp
//
//  Created by Jojo on 10/02/2026.
import SwiftUI

struct TestView: View {
    // استقبال الـ ViewModel المشترك لضمان تزامن البيانات
    @ObservedObject var viewModel: TestViewModel

    // إعداد الشبكة لعرض كاردين في كل صف (2 تحت 2)
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    // Initializer للسماح بالتشغيل المستقل ولحل أخطاء الاستدعاء
    init(viewModel: TestViewModel = TestViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. الخلفية
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .ignoresSafeArea()
                
                // 2. المحتوى الرئيسي
                VStack(alignment: .leading, spacing: 20) {
                    Text("Assignment")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 90)
                    
                    // رابط الانتقال لصفحة الاختبار مع تمرير الـ ViewModel
                    NavigationLink(destination: BurnoutCheckView(viewModel: viewModel)) {
                        startTestBanner
                    }

                    Text("Your Reflection")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // عرض الكروت في شبكة عمودية
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.reflections) { reflection in
                                ReflectionCard(reflection: reflection) {
                                    viewModel.toggleCard(id: reflection.id)
                                }
                                .simultaneousGesture(
                                    LongPressGesture(minimumDuration: 0.8)
                                        .onEnded { _ in
                                            let impact = UIImpactFeedbackGenerator(style: .heavy)
                                            impact.impactOccurred()
                                            
                                            viewModel.itemToDelete = reflection
                                            viewModel.showDeleteAlert = true
                                        }
                                )
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
                .padding(.horizontal, 25)
                .blur(radius: viewModel.reflections.contains(where: { $0.isExpanded }) ? 10 : 0)
                
                // 3. طبقة الكارد المكبر (Expanded Overlay)
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
            .alert("Delete Reflection", isPresented: $viewModel.showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let item = viewModel.itemToDelete {
                        viewModel.deleteReflection(id: item.id)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this reflection? This action cannot be undone.")
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var startTestBanner: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                Text("Start New Assignment")
                    .font(.headline)
            }

            Text("Elevated Stress detected, help us understand your rhythm.")
                .font(.caption)
                .opacity(0.8)
                .frame(maxWidth: .infinity, alignment: .leading) // 👈 هذا يخلي كل الأسطر على اليسار
                .multilineTextAlignment(.leading) // 👈 مهم لمحاذاة الأسطر التالية

            Text("Check up")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity).frame(height: 35)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )

    }
}

// ✅ تصميم الكارد الصغير
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
                    .padding(5)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 147)
            .frame(height: 160)
        }
    }
}

// ✅ تصميم الكارد المكبر مع إضافة النقاط عند القلب
struct ExpandedCardView: View {
    let reflection: ReflectionModel
    let action: () -> Void
    var body: some View {
        ZStack {
            ZStack {
                // الخلفية الأساسية
                RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1))
                
                // الإطار الداخلي
                RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1).padding(10)
                
                // الإطار الخارجي
                RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                
                // ✨ إضافة النقاط في الزوايا فقط عند قلب الكارد
                if reflection.isFlipped {
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
                    .padding(25) // لضمان وجود النقاط داخل الإطار الداخلي
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0)) // لكي لا تظهر النقاط مقلوبة برمجياً
                }
                
                // المحتوى (نص العنوان أو نص التفاصيل)
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
            .onTapGesture {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    action()
                }
            }
        }
    }
}

#Preview {
    TestView(viewModel: TestViewModel())
}
