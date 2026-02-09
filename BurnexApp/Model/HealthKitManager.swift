//
//  HealthKitManager.swift
//  BurnexApp
//
//  Created by Jojo on 07/02/2026.
import HealthKit

class HealthManager {
    let healthStore = HKHealthStore()

    // الأنواع التي نحتاج لقراءتها
    let typesToRead: Set = [
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
    ]

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, _ in
            completion(success)
        }
    }

    // جلب آخر قيمة لـ HRV
    func fetchLatestHRV(completion: @escaping (String) -> Void) {
        let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        fetchLatestSample(for: hrvType) { sample in
            guard let sample = sample as? HKQuantitySample else { completion("--"); return }
            let value = sample.quantity.doubleValue(for: HKUnit(from: "ms"))
            completion("\(Int(value)) ms")
        }
    }

    // جلب آخر قيمة لـ RHR (ضربات القلب وقت الراحة)
    func fetchLatestRHR(completion: @escaping (String) -> Void) {
        let rhrType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        fetchLatestSample(for: rhrType) { sample in
            guard let sample = sample as? HKQuantitySample else { completion("--"); return }
            let value = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            completion("\(Int(value)) BPM")
        }
    }

    // جلب ساعات النوم لآخر 24 ساعة (كنسبة مئوية تقريبية من هدف 8 ساعات)
    func fetchSleep(completion: @escaping (String) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let samples = samples as? [HKCategorySample] else { completion("0%"); return }
            
            let totalSleepTime = samples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
            let hours = totalSleepTime / 3600
            let percentage = min(Int((hours / 8.0) * 100), 100) // افترضنا الهدف 8 ساعات
            completion("\(percentage)%")
        }
        healthStore.execute(query)
    }

    private func fetchLatestSample(for type: HKQuantityType, completion: @escaping (HKSample?) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            completion(samples?.first)
        }
        healthStore.execute(query)
    }
}
