//
//  Untitled.swift
//  BurnexApp
//
//  Created by Jojo on 09/02/2026.

import SwiftUI
import HealthKit
import Combine

class AnalysisViewModel: ObservableObject {
    @Published var chartData: [HealthDataPoint] = []
    @Published var selectedOption: String = "All"
    @Published var selectedTimeRange: String = "D"
    @Published var scrollPosition: Date = Date()
    @Published var rawSelectedDate: Date? = nil
    
    private let healthManager = HealthManager()

    private var dataFetchStartDate: Date {
        Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    }

    func fetchChartData() {
        healthManager.requestAuthorization { success in
            if success {
                self.loadHealthDataForChart(from: self.dataFetchStartDate)
            }
        }
    }

    private func loadHealthDataForChart(from startDate: Date) {
        DispatchQueue.main.async { self.chartData = [] }
        
        if selectedOption == "All" || selectedOption == "Sleep" { fetchSleepData(start: startDate) }
        if selectedOption == "All" || selectedOption == "HRV" {
            fetchQuantityData(identifier: .heartRateVariabilitySDNN, label: "HRV", unit: HKUnit(from: "ms"), start: startDate)
        }
        if selectedOption == "All" || selectedOption == "RHR" {
            fetchQuantityData(identifier: .restingHeartRate, label: "RHR", unit: HKUnit(from: "count/min"), start: startDate)
        }
    }

    private func fetchQuantityData(identifier: HKQuantityTypeIdentifier, label: String, unit: HKUnit, start: Date) {
        let type = HKQuantityType.quantityType(forIdentifier: identifier)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]) { _, samples, _ in
            if let samples = samples as? [HKQuantitySample], !samples.isEmpty {
                let points = samples.map { HealthDataPoint(date: $0.endDate, value: $0.quantity.doubleValue(for: unit), type: label) }
                DispatchQueue.main.async { self.updateChart(with: points) }
            }
        }
        healthManager.healthStore.execute(query)
    }

    private func fetchSleepData(start: Date) {
        let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            if let samples = samples as? [HKCategorySample], !samples.isEmpty {
                let points = samples.map { HealthDataPoint(date: $0.endDate, value: $0.endDate.timeIntervalSince($0.startDate) / 3600, type: "Sleep") }
                DispatchQueue.main.async { self.updateChart(with: points) }
            }
        }
        healthManager.healthStore.execute(query)
    }

    private func updateChart(with points: [HealthDataPoint]) {
        let grouped = Dictionary(grouping: points) { Calendar.current.startOfDay(for: $0.date) }
        let dailyPoints = grouped.map { (key, value) in
            HealthDataPoint(date: key, value: value.map { $0.value }.reduce(0, +) / Double(value.count), type: value.first?.type ?? "")
        }
        self.chartData.append(contentsOf: dailyPoints)
        self.chartData.sort { $0.date < $1.date }
    }

    func calculateSummary(for type: String) -> SummaryData {
        let calendar = Calendar.current
        let now = Date()
        
        let unit: Calendar.Component = {
            switch selectedTimeRange {
            case "D": return .day
            case "W": return .weekOfYear
            case "M": return .month
            case "Y": return .year
            default: return .day
            }
        }()
        
        guard let currentRangeStart = calendar.date(byAdding: unit, value: -1, to: now),
              let previousRangeStart = calendar.date(byAdding: unit, value: -2, to: now) else {
            return SummaryData()
        }
        
        let currentData = chartData.filter { $0.type == type && $0.date >= currentRangeStart && $0.date <= now }
        let previousData = chartData.filter { $0.type == type && $0.date >= previousRangeStart && $0.date < currentRangeStart }
        
        if currentData.isEmpty { return SummaryData() }
        
        let currentAvg = currentData.map { $0.value }.reduce(0, +) / Double(currentData.count)
        let previousAvg = previousData.isEmpty ? currentAvg : previousData.map { $0.value }.reduce(0, +) / Double(previousData.count)
        let diff = previousAvg == 0 ? 0 : ((currentAvg - previousAvg) / previousAvg) * 100
        
        var state: SummaryData.ComparisonState = .normal
        var status = "Normal"
        
        if abs(diff) < 5 {
            status = "Normal"; state = .normal
        } else if diff > 5 {
            status = (type == "RHR") ? "Low" : "Great"
            state = (type == "RHR") ? .low : .great
        } else {
            status = (type == "RHR") ? "Great" : "Low"
            state = (type == "RHR") ? .great : .low
        }
        
        return SummaryData(status: status, percentageText: String(format: "%.1f%%", abs(diff)), state: state)
    }
}
