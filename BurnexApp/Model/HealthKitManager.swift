//
//  HealthKitManager.swift
//  BurnexApp
//
//  Created by Jojo on 07/02/2026.

import Foundation
import HealthKit

final class HealthKitManager {
    private let healthStore = HKHealthStore()

    func requestHealthAuth() {
        // نتحقق إذا كان الجهاز يدعم الهيلث
        guard HKHealthStore.isHealthDataAvailable() else { return }

        // أنواع البيانات التي نريد قراءتها من تطبيق الصحة الأصلي
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        ]

        // طلب الإذن (يظهر مرة واحدة فقط)
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, _ in
            if success {
                print("تم الربط مع تطبيق الصحة بنجاح")
            }
        }
    }
}
