//
//  HealthKitManager.swift
//  BurnexApp
//
//  Created by Jojo on 07/02/2026.
import HealthKit
//
//class HealthManager {
//    let healthStore = HKHealthStore()
//
//    // الأنواع التي نحتاج لقراءتها
//    let typesToRead: Set = [
//        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
//        HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
//        HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
//    ]
//
//    func requestAuthorization(completion: @escaping (Bool) -> Void) {
//        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, _ in
//            completion(success)
//        }
//    }
//
//    // جلب آخر قيمة لـ HRV
//    func fetchLatestHRV(completion: @escaping (String) -> Void) {
//        let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
//        fetchLatestSample(for: hrvType) { sample in
//            guard let sample = sample as? HKQuantitySample else { completion("--"); return }
//            let value = sample.quantity.doubleValue(for: HKUnit(from: "ms"))
//            completion("\(Int(value)) ms")
//        }
//    }
//
//    // جلب آخر قيمة لـ RHR (ضربات القلب وقت الراحة)
//    func fetchLatestRHR(completion: @escaping (String) -> Void) {
//        let rhrType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
//        fetchLatestSample(for: rhrType) { sample in
//            guard let sample = sample as? HKQuantitySample else { completion("--"); return }
//            let value = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
//            completion("\(Int(value)) BPM")
//        }
//    }
//
//    // جلب ساعات النوم لآخر 24 ساعة (كنسبة مئوية تقريبية من هدف 8 ساعات)
//    func fetchSleep(completion: @escaping (String) -> Void) {
//        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { _, samples, _ in
//            guard let samples = samples as? [HKCategorySample] else { completion("0%"); return }
//            
//            let totalSleepTime = samples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
//            let hours = totalSleepTime / 3600
//            let percentage = min(Int((hours / 8.0) * 100), 100) // افترضنا الهدف 8 ساعات
//            completion("\(percentage)%")
//        }
//        healthStore.execute(query)
//    }
//
//    private func fetchLatestSample(for type: HKQuantityType, completion: @escaping (HKSample?) -> Void) {
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, _ in
//            completion(samples?.first)
//        }
//        healthStore.execute(query)
//    }
//    func fetchHistoricalData(days: Int, completion: @escaping ([Double], [Double], [Double]) -> Void) {
//            // البيانات التجريبية لمحاكاة حالة "الإجهاد" (Stress)
//            // HRV منخفض، RHR مرتفع، وساعات نوم قليلة
//            let mockHRV = [60.0, 58.0, 62.0, 55.0, 50.0, 48.0, 45.0, 42.0, 40.0, 38.0]
//            let mockRHR = [65.0, 64.0, 66.0, 68.0, 70.0, 72.0, 75.0, 78.0, 80.0, 82.0]
//            let mockSleep = [8.0, 7.5, 8.2, 7.0, 6.0, 5.5, 5.0, 4.5, 4.0, 3.5]
//            
//            completion(mockHRV, mockRHR, mockSleep)
//        }
//}

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

    // جلب ساعات النوم لآخر 24 ساعة
    func fetchSleep(completion: @escaping (String) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let samples = samples as? [HKCategorySample] else { completion("0%"); return }
            
            let totalSleepTime = samples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
            let hours = totalSleepTime / 3600
            let percentage = min(Int((hours / 8.0) * 100), 100)
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

    // MARK: - دالة جلب البيانات التاريخية للـ Alert (المدمجة)
    func fetchHistoricalData(days: Int, completion: @escaping ([Double], [Double], [Double]) -> Void) {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -days, to: endDate)!
        
        let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let rhrType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let group = DispatchGroup()
        var hrvResults: [Double] = []
        var rhrResults: [Double] = []
        var sleepResults: [Double] = []
        
        // 1. جلب بيانات HRV الحقيقية
        group.enter()
        fetchDailyAverages(for: hrvType, unit: HKUnit(from: "ms"), startDate: startDate) { values in
            hrvResults = values
            group.leave()
        }
        
        // 2. جلب بيانات RHR الحقيقية
        group.enter()
        fetchDailyAverages(for: rhrType, unit: HKUnit(from: "count/min"), startDate: startDate) { values in
            rhrResults = values
            group.leave()
        }
        
        // 3. جلب بيانات النوم الحقيقية
        group.enter()
        fetchDailySleep(startDate: startDate) { values in
            sleepResults = values
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(hrvResults, rhrResults, sleepResults)
        }
    }

    // Helpers لجلب البيانات الحقيقية من HealthKit
    private func fetchDailyAverages(for type: HKQuantityType, unit: HKUnit, startDate: Date, completion: @escaping ([Double]) -> Void) {
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: nil, options: .discreteAverage, anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = { _, results, _ in
            var values: [Double] = []
            results?.enumerateStatistics(from: startDate, to: Date()) { statistics, _ in
                let value = statistics.averageQuantity()?.doubleValue(for: unit) ?? 0.0
                values.append(value)
            }
            completion(values)
        }
        healthStore.execute(query)
    }

    private func fetchDailySleep(startDate: Date, completion: @escaping ([Double]) -> Void) {
        let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            guard let samples = samples as? [HKCategorySample] else { completion([]); return }
            
            let grouped = Dictionary(grouping: samples) { Calendar.current.startOfDay(for: $0.endDate) }
            let dailyValues = grouped.map { (_, samples) in
                samples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) } / 3600
            }.sorted()
            completion(dailyValues)
        }
        healthStore.execute(query)
    }
}
