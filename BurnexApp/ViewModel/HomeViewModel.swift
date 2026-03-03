//
//  HomeModel.swift
//  BurnexApp
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var stats: [StatModel] = [
        StatModel(title: "RHR", value: "Loading..."),
        StatModel(title: "Sleep", value: "Loading..."),
        StatModel(title: "HRV", value: "Loading...")
    ]
    
    @Published var showStressAlert: Bool = false
    private let healthManager = HealthManager()
    
    // استخدام AnalysisViewModel للوصول إلى دالة الحساب calculateSummary
    private let analysisViewModel = AnalysisViewModel()

    init() {
        fetchAllHealthData()
    }
    
    func fetchAllHealthData() {
        healthManager.requestAuthorization { success in
            guard success else { return }
            
            // 1. جلب البيانات التاريخية اللازمة للحسابات
            self.analysisViewModel.fetchChartData()
            
            // 2. تحديث الحالات بناءً على بيانات "اليوم" بعد وقت قصير للتأكد من جلب البيانات
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.updateAllStats()
                self.checkAlertTrigger()
            }
        }
    }
    
    private func updateAllStats() {
        // تحديث RHR
        let rhrSummary = analysisViewModel.calculateSummary(for: "RHR")
        self.stats[0].value = rhrSummary.status
        
        // تحديث Sleep
        let sleepSummary = analysisViewModel.calculateSummary(for: "Sleep")
        self.stats[1].value = sleepSummary.status
        
        // تحديث HRV
        let hrvSummary = analysisViewModel.calculateSummary(for: "HRV")
        self.stats[2].value = hrvSummary.status
    }

    private func checkAlertTrigger() {
        // التحقق إذا كان هناك انحراف (High أو Low) في مؤشرين على الأقل
        let statuses = [
            analysisViewModel.calculateSummary(for: "RHR").status,
            analysisViewModel.calculateSummary(for: "Sleep").status,
            analysisViewModel.calculateSummary(for: "HRV").status
        ]
        
        let deviations = statuses.filter { $0 == "Low" || $0 == "High" }.count
        
        withAnimation(.spring()) {
            self.showStressAlert = (deviations >= 2)
        }
    }
    
    func flipCard(at index: Int) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            stats[index].isFlipped.toggle()
        }
    }
}
