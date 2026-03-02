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
    
    // المتغير المتحكم في ظهور التنبيه (Alert)
    @Published var showStressAlert: Bool = false
    
    private let healthManager = HealthManager()
    
    init() {
        fetchAllHealthData()
    }
    
    func fetchAllHealthData() {
        healthManager.requestAuthorization { success in
            guard success else { return }
            
            // 1. جلب البيانات اللحظية للكروت
            self.fetchCurrentStats()
            
            // 2. تحليل البيانات التاريخية (آخر 10 أيام) للـ Alert
            self.analyzeHealthTrends()
        }
    }
    
    private func fetchCurrentStats() {
        healthManager.fetchLatestRHR { v in DispatchQueue.main.async { self.stats[0].value = v } }
        healthManager.fetchSleep { v in DispatchQueue.main.async { self.stats[1].value = v } }
        healthManager.fetchLatestHRV { v in DispatchQueue.main.async { self.stats[2].value = v } }
    }
    
    private func analyzeHealthTrends() {
       
        healthManager.fetchHistoricalData(days: 10) { hrvData, rhrData, sleepData in
            DispatchQueue.main.async {
                let hrvDeviated = self.isDeviating(data: hrvData, isIncreaseBad: false)
                let rhrDeviated = self.isDeviating(data: rhrData, isIncreaseBad: true)
                let sleepDeviated = self.isDeviating(data: sleepData, isIncreaseBad: false)
                
                let totalDeviations = [hrvDeviated, rhrDeviated, sleepDeviated].filter { $0 == true }.count
                
                withAnimation(.spring()) {
                    self.showStressAlert = (totalDeviations >= 2)
                }
            }
        }
    }
    
    private func isDeviating(data: [Double], isIncreaseBad: Bool) -> Bool {
        // التأكد من وجود بيانات كافية (10 أيام)
        guard data.count >= 10 else { return false }
        
        // 1. حساب الـ Baseline (متوسط الـ 10 أيام كاملة)
        let baseline = data.reduce(0, +) / Double(data.count)
        
        // 2. حساب الـ Trend الحالي (آخر 5 أيام)
        let last5Days = Array(data.suffix(5))
        let currentTrend = last5Days.reduce(0, +) / Double(last5Days.count)
        
        // 3. تحديد نسبة الانحراف (مثلاً 10% كمعيار للتغير الملحوظ)
        let threshold = 0.10
        
        if isIncreaseBad {
            // انحراف لو الـ Trend أعلى من الـ Baseline بـ 10% (مثل نبض القلب)
            return currentTrend > (baseline * (1 + threshold))
        } else {
            // انحراف لو الـ Trend أقل من الـ Baseline بـ 10% (مثل HRV أو النوم)
            return currentTrend < (baseline * (1 - threshold))
        }
    }
    
    func flipCard(at index: Int) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            stats[index].isFlipped.toggle()
        }
    }
}
