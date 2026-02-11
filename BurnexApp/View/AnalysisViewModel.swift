//
//  Untitled.swift
//  BurnexApp
//
//  Created by Jojo on 09/02/2026.

import SwiftUI
import Charts
import HealthKit
import Foundation
import Combine


// MARK: - 1. DATA MODELS
struct HealthDataPoint: Identifiable {
    let id = UUID()
    var date: Date
    var value: Double
    var type: String // يحدد النوع (HRV, RHR, Sleep)
}

struct SummaryData {
    var status: String = "No Data"
    var percentageText: String = ""
    var state: ComparisonState = .noData
    
    // تعريف الحالات للمقارنة مع الألوان والأيقونات
    enum ComparisonState {
        case great, normal, low, noData
        
        var color: Color {
            switch self {
            case .great: return .white
            case .normal: return .white
            case .low: return .white
            case .noData: return .gray
            }
        }
    }
}

// MARK: - 2. VIEW MODEL
class AnalysisViewModel: ObservableObject {
    @Published var chartData: [HealthDataPoint] = []
    @Published var selectedOption: String = "All"
    @Published var selectedTimeRange: String = "W"
    @Published var scrollPosition: Date = Date()
    @Published var rawSelectedDate: Date? = nil
    
    private let healthManager = HealthManager()

    // نحدد تاريخ البداية لجلب البيانات (سنة كاملة للماضي لدعم السكرول)
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

    // MARK: - Comparison Logic (منطق المقارنة الذكي)
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
            // في RHR الزيادة سيئة، في الباقي جيدة
            status = (type == "RHR") ? "Low" : "Great"
            state = (type == "RHR") ? .low : .great
        } else {
            status = (type == "RHR") ? "Great" : "Low"
            state = (type == "RHR") ? .great : .low
        }
        
        return SummaryData(status: status, percentageText: String(format: "%.1f%%", abs(diff)), state: state)
    }
}

// MARK: - 3. MAIN VIEW
struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    let chartColors: KeyValuePairs<String, Color> = ["Sleep": .blue, "HRV": .purple, "RHR": .orange]///الوان الشارت
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    headerView
                    pickerView.padding(.top, 15)

                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            dateHeader
                            Spacer()
                            filterMenu.padding(.trailing, 16).padding(.top, 16)
                        }
                        mainChartView(height: geometry.size.height * 0.32)
                    }
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)
                    .padding(.top, 25)

                    // قسم الملخص مع المقارنة التلقائية
                    VStack(alignment: .leading, spacing: 25) {
                        summaryRow(title: "HRV")
                        summaryRow(title: "RHR")
                        summaryRow(title: "Sleep")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                    .padding(.top, 25)
                }
            }
        }
        .onAppear { viewModel.fetchChartData() }
    }
}

// MARK: - 4. VIEW COMPONENTS
extension AnalysisView {
    
    private var headerView: some View {
        HStack {
            Text("Analysis").font(.system(size: 34, weight: .bold)).foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 20).padding(.top, 60)
    }

    private var pickerView: some View {
        Picker("", selection: $viewModel.selectedTimeRange) {
            ForEach(["D", "W", "M", "Y"], id: \.self) { Text($0).tag($0) }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 20)
        .onChange(of: viewModel.selectedTimeRange) { _ in viewModel.fetchChartData() }
    }

    private var filterMenu: some View {
        Menu {
            Picker("", selection: $viewModel.selectedOption) {
                ForEach(["All", "Sleep", "HRV", "RHR"], id: \.self) { Text($0).tag($0) }
            }
        } label: {
            HStack(spacing: 4) {
                Text(viewModel.selectedOption)
                Image(systemName: "chevron.down")
            }
            .font(.caption2).bold().padding(6)
            .background(Capsule().fill(.white.opacity(0.1)))
            .foregroundColor(.white)
        }
        .onChange(of: viewModel.selectedOption) { _ in viewModel.fetchChartData() }
    }

    private func mainChartView(height: CGFloat) -> some View {
        Chart {
            ForEach(viewModel.chartData) { d in
                // الخط المنحني الرئيسي
                LineMark(
                    x: .value("Date", d.date, unit: getUnit()),
                    y: .value("Value", d.value)
                )
                .foregroundStyle(by: .value("Type", d.type))
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 3))

                // نقاط الأيام (تختفي في عرض السنة لمنع الازدحام)
                if viewModel.selectedTimeRange != "Y" {
                    PointMark(
                        x: .value("Date", d.date, unit: getUnit()),
                        y: .value("Value", d.value)
                    )
                    .foregroundStyle(by: .value("Type", d.type))
                    .symbolSize(30)
                }
                
                AreaMark(
                    x: .value("Date", d.date, unit: getUnit()),
                    y: .value("Value", d.value)
                )
                .foregroundStyle(by: .value("Type", d.type))
                .opacity(0.1)
            }

            if let selectedDate = viewModel.rawSelectedDate {
                RuleMark(x: .value("Selected", selectedDate))
                    .foregroundStyle(.white.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
            }
        }
        .chartForegroundStyleScale(chartColors)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: getVisibleLength())
        .chartScrollPosition(initialX: Date())
        .chartScrollPosition(x: $viewModel.scrollPosition)
        .chartXAxis { configureXAxis() }
        .chartYAxis { AxisMarks(position: .leading) }
        .animation(.smooth, value: viewModel.selectedTimeRange)
        .frame(height: height)
        .padding(.horizontal)
    }
    
    //MARK: - Summary
    ///تصميم صف الملخص مع دعم الألوان والحالات
    
        private func summaryRow(title: String) -> some View {
            let data = viewModel.calculateSummary(for: title)
            
            return VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.system(size: 16, weight: .semibold)).foregroundColor(.gray)
                HStack(alignment: .center, spacing: 8) {
                    // نص الحالة (Great, Normal, Low)
                    Text(data.status)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(data.state.color)
                    
                    // عرض النسبة المئوية فقط بجانب النص بدون سهم
                    if data.state != .noData {
                        Text("\(data.percentageText)")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(data.state.color)
                    }
                }
            }
        }

    private func getUnit() -> Calendar.Component {
        switch viewModel.selectedTimeRange {
        case "D": return .hour
        case "W": return .day
        case "M": return .day
        case "Y": return .month
        default: return .day
        }
    }

    @AxisContentBuilder
    private func configureXAxis() -> some AxisContent {
        switch viewModel.selectedTimeRange {
        case "D": AxisMarks(values: .stride(by: .hour, count: 4)) { _ in AxisValueLabel(format: .dateTime.hour()); AxisGridLine() }
        case "W": AxisMarks(values: .stride(by: .day, count: 1)) { _ in AxisValueLabel(format: .dateTime.weekday(.narrow)); AxisGridLine() }
        case "M": AxisMarks(values: .stride(by: .day, count: 5)) { _ in AxisValueLabel(format: .dateTime.day()); AxisGridLine() }
        case "Y": AxisMarks(values: .stride(by: .month, count: 1)) { _ in AxisValueLabel(format: .dateTime.month(.narrow)); AxisGridLine() }
        default: AxisMarks()
        }
    }

    private func getVisibleLength() -> Double {
        let day: Double = 3600 * 24
        switch viewModel.selectedTimeRange {
        case "D": return day
        case "W": return day * 7
        case "M": return day * 30
        case "Y": return day * 365
        default: return day * 7
        }
    }

    private var dateHeader: some View {
        Text(getFormattedDate(for: viewModel.scrollPosition))
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundColor(.gray)
            .padding([.top, .leading], 16)
    }

    private func getFormattedDate(for date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        switch viewModel.selectedTimeRange {
        case "D":
            formatter.dateFormat = "d MMMM yyyy"
            return formatter.string(from: date)
        case "W":
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            formatter.dateFormat = "d MMM"
            return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek)), \(calendar.component(.year, from: endOfWeek))"
        case "M":
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        case "Y":
            formatter.dateFormat = "yyyy"
            return formatter.string(from: date)
        default: return ""
        }
    }
}
#Preview {
    HomeView()
}
