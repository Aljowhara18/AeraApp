//
//  PrivacyPolicyView.swift
//  Burnex
//
//  Created by Maram on 21/09/1447 AH.
//

//import SwiftUI
//
//struct PrivacyPolicyView: View {
//    @Environment(\.dismiss) var dismiss // لإغلاق الصفحة عند الضغط على Done
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // الحفاظ على هوية Burnex البصرية
//                Color.black.ignoresSafeArea()
//                
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 28) {
//                        
//                        // المقدمة
//                        Text("Your privacy is our priority. Burnex is designed to help you manage burnout while keeping your health data secure and private.")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                            .padding(.bottom, 10)
//
//                        // القسم الأول: استخدام البيانات
//                        privacySection(
//                            title: "1. Data Usage",
//                            content: "Burnex analyzes HealthKit metrics, including Heart Rate Variability (HRV), Resting Heart Rate (RHR), and Sleep data. This information is used solely to provide insights into your burnout risk and recovery trends."
//                        )
//                        
//                        // القسم الثاني: المعالجة المحلية (نقطة قوة لأبل)
//                        privacySection(
//                            title: "2. Local Processing",
//                            content: "All health data is processed locally on your device. We do not use your health information for any purpose other than providing the core functionality of the app."
//                        )
//                        
//                        // القسم الثالث: عدم مشاركة البيانات (شرط أساسي لأبل)
//                        privacySection(
//                            title: "3. Third-Party Sharing",
//                            content: "We do not sell, trade, or share your health data with third-party advertisers, data brokers, or any other external entities."
//                        )
//                        
//                        // القسم الرابع: التخزين والأمان
//                        privacySection(
//                            title: "4. Storage & Security",
//                            content: "Burnex does not store your health data on external servers. All information remains securely within Apple’s HealthKit ecosystem on your device."
//                        )
//                        
//                        Spacer()
//                    }
//                    .padding(24)
//                }
//            }
//            .navigationTitle("Privacy Policy")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                    .fontWeight(.bold)
//                    .foregroundColor(.blue)
//                }
//            }
//            // تنسيق الهيدر العلوي
//            .toolbarBackground(.visible, for: .navigationBar)
//            .toolbarBackground(Color.black, for: .navigationBar)
//        }
//        // ضبط الثيم الغامق
//        .preferredColorScheme(.dark)
//    }
//    
//    // Helper function لترتيب الفقرات بشكل أنيق
//    private func privacySection(title: String, content: String) -> some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text(title)
//                .font(.headline)
//                .foregroundColor(.blue)
//            Text(content)
//                .font(.system(size: 15))
//                .foregroundColor(.white.opacity(0.8))
//                .lineSpacing(4)
//        }
//    }
//}
//
//#Preview {
//    PrivacyPolicyView()
//}

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        
                        Text("Your privacy is our priority. Burnex is designed to help you manage burnout while keeping your health data secure and private.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)

                        // 1. استخدام البيانات
                        privacySection(
                            title: "1. Data Usage",
                            content: "Burnex analyzes HealthKit metrics, including Heart Rate Variability (HRV), Resting Heart Rate (RHR), and Sleep data. This information is used solely to provide insights into your burnout risk and recovery trends."
                        )
                        
                        // 2. المعالجة المحلية (القوة التقنية)
                        privacySection(
                            title: "2. Local Processing",
                            content: "All health data is processed locally on your device. We do not use your health information for any purpose other than providing the core functionality of the app."
                        )
                        
                        // 3. عدم مشاركة البيانات (الأمان)
                        privacySection(
                            title: "3. Third-Party Sharing",
                            content: "We do not sell, trade, or share your health data with third-party advertisers, data brokers, or any other external entities."
                        )
                        
                        // 4. التخزين والأمان
                        privacySection(
                            title: "4. Storage & Security",
                            content: "Burnex does not store your health data on external servers. All information remains securely within Apple’s HealthKit ecosystem on your device."
                        )
                        
                        // 5. تحكم اليوزر
                        privacySection(
                            title: "5. User Control",
                            content: "You have full authority over your data. You can revoke HealthKit permissions at any time through your iPhone settings under Privacy & Security."
                        )
                        
                        // التواصل
                        VStack(alignment: .leading, spacing: 10) {
                            Text("6. Contact")
                                .font(.headline)
                                .foregroundColor(.text)
                            Text("For any privacy concerns, feel free to reach out via LinkedIn.")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 4) {
                                Link("Visit LinkedIn Profile", destination: URL(string: "https://www.linkedin.com/in/maram-bin-jubair/")!)
                                Image(systemName: "arrow.up.right")}
                                        .font(.system(size: 12))
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.text)
                                .padding(.top, 5)
                        }
                        
                        Spacer()
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .frame(width: 60)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .foregroundColor(.text)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
    
    private func privacySection(title: LocalizedStringKey, content: LocalizedStringKey) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.text)
            Text(content)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
        }
    }
}
#Preview {
    PrivacyPolicyView()
}
