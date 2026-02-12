import Foundation
import SwiftUI
import Combine
// إذا احتجت أنواع HealthKit هنا مستقبلاً يمكنك إبقاؤه
// import HealthKit

// ViewModel لشاشة الساعة يقرأ من HealthManager ويحسب المتوسط
final class OverviewWatchViewModel: ObservableObject {
    @Published var sleepPercent: Double = 0           // 0...100
    @Published var hrvMS: Double = 0                  // بالمللي ثانية
    @Published var rhrBPM: Double = 0                 // نبض/دقيقة
    
    @Published var sleepText: String = "--%"
    @Published var hrvText: String = "-- ms"
    @Published var rhrText: String = "-- BPM"
    
    // تقدم الحلقة: متوسط مطبّع لثلاثة مؤشرات (0...1)
    @Published var averageProgress: Double = 0.0
    
    private let health = HealthManager()
    
    init() {
        requestAndFetch()
    }
    
    func requestAndFetch() {
        health.requestAuthorization { [weak self] (ok: Bool) in
            guard let self = self, ok else { return }
            self.fetchAll()
        }
    }
    
    private func fetchAll() {
        // Sleep
        health.fetchSleep { [weak self] (s: String) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.sleepText = s
                self.sleepPercent = Self.extractPercent(from: s)
                self.recomputeAverage()
            }
        }
        // HRV
        health.fetchLatestHRV { [weak self] (s: String) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hrvText = s
                self.hrvMS = Self.extractNumber(from: s)
                self.recomputeAverage()
            }
        }
        // RHR
        health.fetchLatestRHR { [weak self] (s: String) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.rhrText = s
                self.rhrBPM = Self.extractNumber(from: s)
                self.recomputeAverage()
            }
        }
    }
    
    private func recomputeAverage() {
        // تطبيع HRV إلى 0...100 بافتراض 20..120 ms
        let hrvNorm = normalize(value: hrvMS, min: 20, max: 120)
        // تطبيع RHR إلى 0...100 بافتراض 40..100 BPM (الأقل أفضل) => نعكس
        let rhrRaw = normalize(value: rhrBPM, min: 40, max: 100)
        let rhrNorm = 100 - rhrRaw
        // Sleep جاهز كنسبة 0..100
        let sleepNorm = clamp(sleepPercent, min: 0, max: 100)
        
        let avg = (sleepNorm + hrvNorm + rhrNorm) / 3.0
        averageProgress = max(0, min(1, avg / 100.0))
    }
    
    private func normalize(value: Double, min: Double, max: Double) -> Double {
        guard max > min else { return 0 }
        let v = (value - min) / (max - min) * 100.0
        return clamp(v, min: 0, max: 100)
    }
    
    private func clamp(_ v: Double, min: Double, max: Double) -> Double {
        Swift.max(min, Swift.min(max, v))
    }
    
    private static func extractPercent(from text: String) -> Double {
        // مثال: "78%" => 78
        let digits = text.filter { $0.isNumber }
        return Double(digits) ?? 0
    }
    
    private static func extractNumber(from text: String) -> Double {
        // مثال: "65 BPM" أو "42 ms" => 65 أو 42
        let digits = text.filter { $0.isNumber || $0 == "." }
        return Double(digits) ?? 0
    }
}
