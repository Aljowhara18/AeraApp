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



/*
// MARK: - ViewModel
class AnalysisViewModel: ObservableObject {
    @Published var chartData: [HealthDataPoint] = []
    @Published var selectedOption: String = "Sleep"
    
    @Published var sleepSummary = SummaryData()
    @Published var hrvSummary = SummaryData()
    @Published var rhrSummary = SummaryData()
    
    let healthStore = HKHealthStore()

    func fetchChartData() {
        fetchRealSummaries()
        
        switch selectedOption {
        case "All": fetchAllDataForChart()
        case "Sleep": fetchSleepData()
        case "HRV": fetchQuantityData(for: .heartRateVariabilitySDNN, unit: HKUnit(from: "ms"), typeName: "HRV")
        case "RHR": fetchQuantityData(for: .restingHeartRate, unit: HKUnit(from: "count/min"), typeName: "RHR")
        default: break
        }
    }

    private func fetchRealSummaries() {
        DispatchQueue.main.async {
            self.sleepSummary = SummaryData(status: "Great", percentageText: "44.2% then last week", color: Color.blue)
            self.hrvSummary = SummaryData(status: "Great", percentageText: "44.2% then last week", color: Color.blue)
            self.rhrSummary = SummaryData(status: "Normal", percentageText: "10% stable", color: Color.gray)
        }
    }

    private func fetchSleepData(isAppend: Bool = false) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        let calendar = Calendar.current
        var temp: [HealthDataPoint] = []
        let group = DispatchGroup()

        for i in 0..<7 {
            group.enter()
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let predicate = HKQuery.predicateForSamples(
                withStart: calendar.startOfDay(for: date),
                end: calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date))!,
                options: .strictStartDate
            )
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                let hours = (samples as? [HKCategorySample])?.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) } ?? 0
                temp.append(HealthDataPoint(day: self.getDayName(for: date), value: hours / 3600, type: "Sleep"))
                group.leave()
            }
            healthStore.execute(query)
        }
        group.notify(queue: .main) {
            let sorted = temp.sorted { self.date(from: $0.day) < self.date(from: $1.day) }
            if isAppend { self.chartData.append(contentsOf: sorted) } else { self.chartData = sorted }
        }
    }

    private func fetchQuantityData(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, typeName: String, isAppend: Bool = false) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        let calendar = Calendar.current
        var temp: [HealthDataPoint] = []
        let group = DispatchGroup()

        for i in 0..<7 {
            group.enter()
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let predicate = HKQuery.predicateForSamples(
                withStart: calendar.startOfDay(for: date),
                end: calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date))!,
                options: .strictStartDate
            )
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .discreteAverage) { _, stats, _ in
                let val = stats?.averageQuantity()?.doubleValue(for: unit) ?? 0
                temp.append(HealthDataPoint(day: self.getDayName(for: date), value: val, type: typeName))
                group.leave()
            }
            healthStore.execute(query)
        }
        group.notify(queue: .main) {
            let sorted = temp.sorted { self.date(from: $0.day) < self.date(from: $1.day) }
            if isAppend { self.chartData.append(contentsOf: sorted) } else { self.chartData = sorted }
        }
    }

    private func fetchAllDataForChart() {
        self.chartData = []
        fetchSleepData(isAppend: true)
        fetchQuantityData(for: .heartRateVariabilitySDNN, unit: HKUnit(from: "ms"), typeName: "HRV", isAppend: true)
        fetchQuantityData(for: .restingHeartRate, unit: HKUnit(from: "count/min"), typeName: "RHR", isAppend: true)
    }

    private func getDayName(for date: Date) -> String {
        let formatter = DateFormatter(); formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
    
    private func date(from dayName: String) -> Date {
        let formatter = DateFormatter(); formatter.dateFormat = "EEE"
        return formatter.date(from: dayName) ?? Date()
    }
}

// MARK: - View
struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    @State private var selectedTimeRange = "W"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // ضبط الصورة الخلفية لتناسب عرض الشاشة الفعلي دون تضخيم
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Header
                    HStack {
                        Text("Analysis")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Picker
                    Picker("", selection: $selectedTimeRange) {
                        ForEach(["D", "W", "M", "Y"], id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                    
                    // Chart Card
                    VStack(spacing: 8) {
                        HStack {
                            Spacer()
                            Menu {
                                Picker("", selection: $viewModel.selectedOption) {
                                    ForEach(["All", "Sleep", "HRV", "RHR"], id: \.self) { Text($0).tag($0) }
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Text(viewModel.selectedOption)
                                    Image(systemName: "chevron.down")
                                }
                                .font(.system(size: 12, weight: .bold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(Color.black.opacity(0.6)))
                                .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.trailing, 8)
                        .onChange(of: viewModel.selectedOption) { _ in
                            viewModel.fetchChartData()
                        }
                        
                        // Chart
                        Chart {
                            ForEach(viewModel.chartData) { d in
                                LineMark(
                                    x: .value("Day", d.day),
                                    y: .value("Value", d.value)
                                )
                                .foregroundStyle(by: .value("Type", d.type))
                                .interpolationMethod(.catmullRom)
                            }
                        }
                        .chartForegroundStyleScale([
                            "Sleep": Color.blue,
                            "HRV": Color.purple,
                            "RHR": Color.orange
                        ])
                        // تحديد ارتفاع نسبي للتشارت ليناسب الشاشة
                        .frame(height: geometry.size.height * 0.25)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 12)
                    }
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.08))
                    )
                    .padding(.horizontal, 20)
                    
                    // Summaries
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            summaryRow(title: "HRV", data: viewModel.hrvSummary)
                            summaryRow(title: "RHR", data: viewModel.rhrSummary)
                            summaryRow(title: "Sleep", data: viewModel.sleepSummary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
            }
        }
        .onAppear { viewModel.fetchChartData() }
    }

    private func summaryRow(title: String, data: SummaryData) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(data.status)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Text(data.percentageText)
                    .font(.system(size: 13))
                    .foregroundColor(data.color)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
*/
 /*
import SwiftUI
import Charts
import HealthKit
import Foundation
import Combine

import SwiftUI
import Charts

// MARK: - Models
struct HealthDataPoint: Identifiable {
    let id = UUID()
    var date: Date
    var value: Double
    var type: String
}

struct SummaryData {
    var status: String = ""
    var percentageText: String = ""
}

// MARK: - ViewModel
class AnalysisViewModel: ObservableObject {
    @Published var chartData: [HealthDataPoint] = []
    @Published var selectedOption: String = "All"
    @Published var selectedTimeRange: String = "W"
    @Published var scrollPosition: Date = Date()
    
    @Published var sleepSummary = SummaryData()
    @Published var hrvSummary = SummaryData()
    @Published var rhrSummary = SummaryData()

    func fetchChartData() {
        generateLogicData()
        fetchRealSummaries()
    }

    private func generateLogicData() {
        var temp: [HealthDataPoint] = []
        let calendar = Calendar.current
        let now = Date()
        let types = selectedOption == "All" ? ["Sleep", "HRV", "RHR"] : [selectedOption]
        
        let count: Int
        let component: Calendar.Component
        
        switch selectedTimeRange {
        case "D": count = 24; component = .hour
        case "W": count = 7; component = .day
        case "M": count = 30; component = .day
        case "Y": count = 12; component = .month
        default: count = 7; component = .day
        }
        
        for i in 0..<count {
            if let date = calendar.date(byAdding: component, value: -i, to: now) {
                for type in types {
                    let val = type == "Sleep" ? Double.random(in: 6...9) : Double.random(in: 45...85)
                    temp.append(HealthDataPoint(date: date, value: val, type: type))
                }
            }
        }
        
        self.chartData = temp.sorted { $0.date < $1.date }
        self.scrollPosition = now
    }

    private func fetchRealSummaries() {
        self.hrvSummary = SummaryData(status: "Great", percentageText: "44.2% then last month")
        self.rhrSummary = SummaryData(status: "Normal", percentageText: "60% then last month")
        self.sleepSummary = SummaryData(status: "Low", percentageText: "40% then last month")
    }
}

// MARK: - View
struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    
    let chartColors: KeyValuePairs<String, Color> = [
        "Sleep": .blue, "HRV": .purple, "RHR": .orange
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 15) { // تقليل المسافة الإجمالية لضمان عدم وجود سكرول
                    headerView
                    pickerView
                    
                    // قسم التشارت
                    VStack(alignment: .leading, spacing: 5) {
                        dateHeader
                        legendView
                        
                        Chart {
                            ForEach(viewModel.chartData) { d in
                                renderLine(for: d)
                                renderArea(for: d)
                            }
                        }
                        .chartForegroundStyleScale(chartColors)
                        .chartXAxis { configureXAxis() }
                        .chartYAxis(.hidden)
                        .chartLegend(.hidden)
                        .chartScrollableAxes(.horizontal)
                        .chartXVisibleDomain(length: getVisibleLength())
                        .chartScrollPosition(x: $viewModel.scrollPosition)
                        .frame(height: geometry.size.height * 0.28)
                        .padding(.horizontal)
                    }
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)
                    
                    // قسم القائمة (المعدل تماماً)
                    VStack(alignment: .leading, spacing: 25) { // مسافة ثابتة بين الصفوف
                        summaryRow(title: "HRV", data: viewModel.hrvSummary)
                        summaryRow(title: "RHR", data: viewModel.rhrSummary)
                        summaryRow(title: "Sleep", data: viewModel.sleepSummary)
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    
                    Spacer() // يدفع العناصر للأعلى لضمان الملاءمة
                }
            }
        }
        .onAppear { viewModel.fetchChartData() }
    }

    // MARK: - Chart Content Builders
    @ChartContentBuilder
    private func renderLine(for d: HealthDataPoint) -> some ChartContent {
        LineMark(x: .value("Date", d.date), y: .value("Value", d.value))
            .foregroundStyle(by: .value("Type", d.type))
            .interpolationMethod(.catmullRom)
            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
    }
    
    @ChartContentBuilder
    private func renderArea(for d: HealthDataPoint) -> some ChartContent {
        AreaMark(x: .value("Date", d.date), y: .value("Value", d.value))
            .foregroundStyle(by: .value("Type", d.type))
            .interpolationMethod(.catmullRom)
            .opacity(0.1)
    }

    // MARK: - Summary Row (تطبيق طلباتك بدقة)
    private func summaryRow(title: String, data: SummaryData) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // العنوان الرمادي
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
            
            HStack(alignment: .center, spacing: 6) {
                // الحالة بالخط العريض
                Text(data.status)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                // السهم والنسبة بلونك المخصص Text
                HStack(spacing: 3) {
                    Image(systemName: "arrow.up.forward") // السهم الرشيق مثل الصورة
                        .font(.system(size: 14, weight: .bold))
                    
                    Text(data.percentageText)
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(Color("Text")) // استخدام اللون الخاص بك
            }
        }
    }

    // MARK: - Helper Logic
    @AxisContentBuilder
    private func configureXAxis() -> some AxisContent {
        switch viewModel.selectedTimeRange {
        case "D":
            AxisMarks(values: .stride(by: .hour, count: 6)) { _ in
                AxisValueLabel(format: .dateTime.hour())
            }
        case "W":
            AxisMarks(values: .stride(by: .day, count: 1)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.narrow))
            }
        case "M":
            AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                AxisValueLabel(format: .dateTime.day())
            }
        case "Y":
            AxisMarks(values: .stride(by: .month, count: 1)) { _ in
                AxisValueLabel(format: .dateTime.month(.narrow))
            }
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
            .font(.caption).fontWeight(.semibold).foregroundColor(.gray).padding([.top, .leading], 16)
    }

    private func getFormattedDate(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"; return f.string(from: date)
    }

    private var headerView: some View {
        HStack {
            Text("Analysis").font(.largeTitle).bold().foregroundColor(.white)
            Spacer()
        }.padding(.horizontal, 20).padding(.top, 10)
    }

    private var pickerView: some View {
        Picker("", selection: $viewModel.selectedTimeRange) {
            ForEach(["D", "W", "M", "Y"], id: \.self) { Text($0).tag($0) }
        }
        .pickerStyle(.segmented).padding(.horizontal, 20)
        .onChange(of: viewModel.selectedTimeRange) { _ in viewModel.fetchChartData() }
    }

    private var legendView: some View {
        HStack {
            if viewModel.selectedOption == "All" {
                HStack(spacing: 12) {
                    indicator(color: .blue, text: "Sleep")
                    indicator(color: .purple, text: "HRV")
                    indicator(color: .orange, text: "RHR")
                }
            }
            Spacer()
            Menu {
                Picker("", selection: $viewModel.selectedOption) {
                    ForEach(["All", "Sleep", "HRV", "RHR"], id: \.self) { Text($0).tag($0) }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedOption)
                    Image(systemName: "chevron.down")
                }
                .font(.caption2).bold().padding(6)
                .background(Capsule().fill(.white.opacity(0.1))).foregroundColor(.white)
            }
        }.padding(.horizontal, 16)
    }

    private func indicator(color: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(text).font(.caption2).foregroundColor(.gray)
        }
    }
}
*/
/* No healthkitsync yet
import SwiftUI
import Charts

// MARK: - Models
struct HealthDataPoint: Identifiable {
    let id = UUID()
    var date: Date
    var value: Double
    var type: String
}

struct SummaryData {
    var status: String = ""
    var percentageText: String = ""
}

// MARK: - ViewModel
class AnalysisViewModel: ObservableObject {
    @Published var chartData: [HealthDataPoint] = []
    @Published var selectedOption: String = "All"
    @Published var selectedTimeRange: String = "W"
    @Published var scrollPosition: Date = Date()
    
    @Published var sleepSummary = SummaryData()
    @Published var hrvSummary = SummaryData()
    @Published var rhrSummary = SummaryData()

    func fetchChartData() {
        generateLogicData()
        fetchRealSummaries()
    }

    private func generateLogicData() {
        var temp: [HealthDataPoint] = []
        let calendar = Calendar.current
        let now = Date()
        let types = selectedOption == "All" ? ["Sleep", "HRV", "RHR"] : [selectedOption]
        
        let count: Int
        let component: Calendar.Component
        
        switch selectedTimeRange {
        case "D": count = 24; component = .hour
        case "W": count = 7; component = .day
        case "M": count = 30; component = .day
        case "Y": count = 12; component = .month
        default: count = 7; component = .day
        }
        
        for i in 0..<count {
            if let date = calendar.date(byAdding: component, value: -i, to: now) {
                for type in types {
                    let val = type == "Sleep" ? Double.random(in: 6...9) : Double.random(in: 45...85)
                    temp.append(HealthDataPoint(date: date, value: val, type: type))
                }
            }
        }
        
        self.chartData = temp.sorted { $0.date < $1.date }
        self.scrollPosition = now
    }

    private func fetchRealSummaries() {
        self.hrvSummary = SummaryData(status: "Great", percentageText: "44.2% then last month")
        self.rhrSummary = SummaryData(status: "Normal", percentageText: "60% then last month")
        self.sleepSummary = SummaryData(status: "Low", percentageText: "40% then last month")
    }
}

// MARK: - View
struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    
    let chartColors: KeyValuePairs<String, Color> = [
        "Sleep": .blue, "HRV": .purple, "RHR": .orange
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 15) {
                    headerView
                    pickerView
                    
                    // قسم التشارت
                    VStack(alignment: .leading, spacing: 5) {
                        dateHeader
                        legendView
                        
                        Chart {
                            ForEach(viewModel.chartData) { d in
                                renderLine(for: d)
                                renderArea(for: d)
                            }
                        }
                        .chartForegroundStyleScale(chartColors)
                        .chartXAxis { configureXAxis() }
                        .chartYAxis(.hidden)
                        .chartLegend(.hidden)
                        .chartScrollableAxes(.horizontal)
                        .chartXVisibleDomain(length: getVisibleLength())
                        .chartScrollPosition(x: $viewModel.scrollPosition)
                        .frame(height: geometry.size.height * 0.28)
                        .padding(.horizontal)
                    }
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)
                    
                    // قسم القائمة مع محاذاة لليسار
                    VStack(alignment: .leading, spacing: 25) {
                        summaryRow(title: "HRV", data: viewModel.hrvSummary)
                        summaryRow(title: "RHR", data: viewModel.rhrSummary)
                        summaryRow(title: "Sleep", data: viewModel.sleepSummary)
                        
                        // إضافة Spacer لضمان بقاء العناصر في الأعلى بمحاذاة يسار صحيحة
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // ضمان تمدد الحاوية لليسار
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                }
            }
        }
        .onAppear { viewModel.fetchChartData() }
    }

    // MARK: - Chart Builders
    @ChartContentBuilder
    private func renderLine(for d: HealthDataPoint) -> some ChartContent {
        LineMark(x: .value("Date", d.date), y: .value("Value", d.value))
            .foregroundStyle(by: .value("Type", d.type))
            .interpolationMethod(.catmullRom)
            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
    }
    
    @ChartContentBuilder
    private func renderArea(for d: HealthDataPoint) -> some ChartContent {
        AreaMark(x: .value("Date", d.date), y: .value("Value", d.value))
            .foregroundStyle(by: .value("Type", d.type))
            .interpolationMethod(.catmullRom)
            .opacity(0.1)
    }

    // MARK: - Summary Row (محاذاة يسار كاملة)
    private func summaryRow(title: String, data: SummaryData) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
            
            HStack(alignment: .center, spacing: 8) {
                Text(data.status)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 3) {
                    Image(systemName: "arrow.up.forward")
                        .font(.system(size: 14, weight: .bold))
                    
                    Text(data.percentageText)
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(Color("Text"))
            }
        }
    }

    // MARK: - Helpers
    @AxisContentBuilder
    private func configureXAxis() -> some AxisContent {
        switch viewModel.selectedTimeRange {
        case "D": AxisMarks(values: .stride(by: .hour, count: 6)) { _ in AxisValueLabel(format: .dateTime.hour()) }
        case "W": AxisMarks(values: .stride(by: .day, count: 1)) { _ in AxisValueLabel(format: .dateTime.weekday(.narrow)) }
        case "M": AxisMarks(values: .stride(by: .day, count: 7)) { _ in AxisValueLabel(format: .dateTime.day()) }
        case "Y": AxisMarks(values: .stride(by: .month, count: 1)) { _ in AxisValueLabel(format: .dateTime.month(.narrow)) }
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
            .font(.caption).fontWeight(.semibold).foregroundColor(.gray).padding([.top, .leading], 16)
    }

    private func getFormattedDate(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"; return f.string(from: date)
    }

    private var headerView: some View {
        HStack {
            Text("Analysis").font(.largeTitle).bold().foregroundColor(.white)
            Spacer()
        }.padding(.horizontal, 20).padding(.top, 10)
    }

    private var pickerView: some View {
        Picker("", selection: $viewModel.selectedTimeRange) {
            ForEach(["D", "W", "M", "Y"], id: \.self) { Text($0).tag($0) }
        }
        .pickerStyle(.segmented).padding(.horizontal, 20)
        .onChange(of: viewModel.selectedTimeRange) { _ in viewModel.fetchChartData() }
    }

    private var legendView: some View {
        HStack {
            if viewModel.selectedOption == "All" {
                HStack(spacing: 12) {
                    indicator(color: .blue, text: "Sleep")
                    indicator(color: .purple, text: "HRV")
                    indicator(color: .orange, text: "RHR")
                }
            }
            Spacer()
            Menu {
                Picker("", selection: $viewModel.selectedOption) {
                    ForEach(["All", "Sleep", "HRV", "RHR"], id: \.self) { Text($0).tag($0) }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedOption)
                    Image(systemName: "chevron.down")
                }
                .font(.caption2).bold().padding(6)
                .background(Capsule().fill(.white.opacity(0.1))).foregroundColor(.white)
            }
        }.padding(.horizontal, 16)
    }

    private func indicator(color: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(text).font(.caption2).foregroundColor(.gray)
        }
    }
}
*/
import SwiftUI
import Charts
import HealthKit

// MARK: - 1. DATA MODELS
/// هذا القسم يحتوي على هياكل البيانات التي نستخدمها لعرض المعلومات في الرسم البياني والملخصات.
struct HealthDataPoint: Identifiable {
    let id = UUID()
    var date: Date
    var value: Double
    var type: String // يحدد النوع (HRV, RHR, Sleep)
}

struct SummaryData {
    var status: String = "Loading..."
    var percentageText: String = ""
}

// MARK: - 2. VIEW MODEL
/// هنا يتم جلب البيانات من HealthKit ومعالجتها قبل عرضها.
class AnalysisViewModel: ObservableObject {
    // الخصائص التي تراقبها الواجهة لتحديث نفسها تلقائياً
    @Published var chartData: [HealthDataPoint] = []
    @Published var selectedOption: String = "All"      // الفلتر (الكل، نوم، الخ)
    @Published var selectedTimeRange: String = "W"     // النطاق الزمني (يوم، اسبوع، الخ)
    @Published var scrollPosition: Date = Date()       // مكان التمرير في الرسم البياني
    @Published var rawSelectedDate: Date? = nil        // التاريخ المختار عند اللمس
    
    @Published var sleepSummary = SummaryData()
    @Published var hrvSummary = SummaryData()
    @Published var rhrSummary = SummaryData()

    private let healthManager = HealthManager()

    // MARK: - Computed Properties
    /// حساب تاريخ البداية بناءً على النطاق الزمني المختار (D, W, M, Y)
    var chartStartDate: Date {
        let calendar = Calendar.current
        let now = Date()
        switch selectedTimeRange {
        case "D": return calendar.startOfDay(for: now)
        case "W": return calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))!
        case "M": return calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: now))!
        case "Y": return calendar.date(byAdding: .month, value: -11, to: calendar.startOfDay(for: now))!
        default: return now
        }
    }

    // MARK: - Data Fetching Methods
    /// الوظيفة الرئيسية لبدء جلب البيانات  من هيلث بعد أخذ الإذن
    // داخل AnalysisViewModel

    // 1. نحدد تاريخ البداية الفعلي لجلب البيانات (مثلاً سنة كاملة للماضي)
    private var dataFetchStartDate: Date {
        Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    }

    func fetchChartData() {
        healthManager.requestAuthorization { success in
            if success {
                // نمرر تاريخ قديم لجلب كل البيانات السابقة
                self.loadHealthDataForChart(from: self.dataFetchStartDate)
                self.fetchRealSummaries()
            }
        }
    }

    private func loadHealthDataForChart(from startDate: Date) {
        DispatchQueue.main.async { self.chartData = [] }
        
        // نستخدم startDate الممرر بدلاً من المحسوب لحظياً
        if selectedOption == "All" || selectedOption == "Sleep" { fetchSleepData(start: startDate) }
        if selectedOption == "All" || selectedOption == "HRV" {
            fetchQuantityData(identifier: .heartRateVariabilitySDNN, label: "HRV", unit: HKUnit(from: "ms"), start: startDate)
        }
        if selectedOption == "All" || selectedOption == "RHR" {
            fetchQuantityData(identifier: .restingHeartRate, label: "RHR", unit: HKUnit(from: "count/min"), start: startDate)
        }
    }

    // MARK: - HealthKit Queries
    /// جلب البيانات الرقمية (مثل نبضات القلب و HRV)
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

    /// جلب بيانات النوم (تحويلها من فترات زمنية إلى ساعات)
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

    // داخل الـ ViewModel، قم بتعديل تحديث البيانات:
    private func updateChart(with points: [HealthDataPoint]) {
        // هذه الإضافة تضمن دمج القراءات التي تحدث في نفس اليوم
        let grouped = Dictionary(grouping: points) { Calendar.current.startOfDay(for: $0.date) }
        let dailyPoints = grouped.map { (key, value) in
            HealthDataPoint(date: key, value: value.map { $0.value }.reduce(0, +) / Double(value.count), type: value.first?.type ?? "")
        }
        
        self.chartData.append(contentsOf: dailyPoints)
        self.chartData.sort { $0.date < $1.date }
    }

    /// جلب ملخصات القيم الأخيرة لعرضها تحت الرسم البياني
    /// تحتاج تعديل ان تكون مربوطة باللوجك
    private func fetchRealSummaries() {
        healthManager.fetchLatestHRV { v in DispatchQueue.main.async { self.hrvSummary = SummaryData(status: v, percentageText: "Latest") } }
        healthManager.fetchLatestRHR { v in DispatchQueue.main.async { self.rhrSummary = SummaryData(status: v, percentageText: "Latest") } }
        healthManager.fetchSleep { v in DispatchQueue.main.async { self.sleepSummary = SummaryData(status: v, percentageText: "Goal Progress") } }
    }
}

// MARK: - 3. MAIN VIEW (الواجهة الرئيسية)
struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    let chartColors: KeyValuePairs<String, Color> = ["Sleep": .blue, "HRV": .purple, "RHR": .orange]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    headerView
                    pickerView.padding(.top, 15)

                    // MARK: Chart Container
                    /// الحاوية التي تضم عنوان التاريخ، زر التصفية، والرسم البياني
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            dateHeader
                            Spacer()
                            filterMenu // زر اختيار (Sleep, HRV, RHR)
                                .padding(.trailing, 16)
                                .padding(.top, 16)
                        }
                        
                        mainChartView(height: geometry.size.height * 0.32)
                    }
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)
                    .padding(.top, 25)

                    // MARK: Summary Section
                    /// عرض البيانات الملخصة في الأسفل
                    VStack(alignment: .leading, spacing: 25) {
                        summaryRow(title: "HRV", data: viewModel.hrvSummary)
                        summaryRow(title: "RHR", data: viewModel.rhrSummary)
                        summaryRow(title: "Sleep", data: viewModel.sleepSummary)
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
    /// مكون الرسم البياني نفسه
    /// هنا التعديل المطلوب امكانية اليوزر يلف لليسار يرجع للاسابيع الاشهر السابقة
    private func mainChartView(height: CGFloat) -> some View {
        Chart {
            ForEach(viewModel.chartData) { d in
                // 1. رسم الخط الرئيسي
                LineMark(
                    x: .value("Date", d.date, unit: getUnit()),
                    y: .value("Value", d.value)
                )
                .foregroundStyle(by: .value("Type", d.type))
                .interpolationMethod(.catmullRom) // لجعل الخط منحني وانسيابي
                .lineStyle(StrokeStyle(lineWidth: 3)) // تسميك الخط قليلاً

                // 2. إضافة نقاط عند كل يوم (اختياري - يعطي شكل احترافي)
                if viewModel.selectedTimeRange != "Y" { // لا نظهر النقاط في عرض السنة لعدم الازدحام
                    PointMark(
                        x: .value("Date", d.date, unit: getUnit()),
                        y: .value("Value", d.value)
                    )
                    .foregroundStyle(by: .value("Type", d.type))
                    .symbolSize(30)
                }
                
                // 3. تظليل خفيف تحت الخط (Area)
                AreaMark(
                    x: .value("Date", d.date, unit: getUnit()),
                    y: .value("Value", d.value)
                )
                .foregroundStyle(by: .value("Type", d.type))
                .opacity(0.1) // شفافية عالية جداً ليكون مجرد ظل ناعم
            }

            // مؤشر الاختيار عند اللمس (الخط المقطع)
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
        .animation(.smooth, value: viewModel.selectedTimeRange) // حركة "Smooth" أفضل للخطوط
        .frame(height: height)
        .padding(.horizontal)
    }
    
    // وظيفة مساعدة لتحديد وحدة الرسم
    private func getUnit() -> Calendar.Component {
        switch viewModel.selectedTimeRange {
        case "D": return .hour
        case "W": return .day
        case "M": return .day
        case "Y": return .month
        default: return .day
        }
    }
    
// ملخص البيانات هنا كذلك نحتاج نعدل اللوجك ونسوي cases لكل حالة كلمة وسهم معين
    private func summaryRow(title: String, data: SummaryData) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.system(size: 16, weight: .semibold)).foregroundColor(.gray)
            HStack(alignment: .center, spacing: 8) {
                Text(data.status).font(.system(size: 28, weight: .bold)).foregroundColor(.white)
                HStack(spacing: 3) {
                    Image(systemName: "arrow.up.forward").font(.system(size: 14, weight: .bold))
                    Text(data.percentageText).font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(Color.purple)
            }
        }
    }
// الباقي ext غير مهم
    // MARK: - Helper Methods (وظائف مساعدة للواجهة)
    @AxisContentBuilder
    private func configureXAxis() -> some AxisContent {
        switch viewModel.selectedTimeRange {
        case "D":
            // عرض الساعات لليوم الواحد
            AxisMarks(values: .stride(by: .hour, count: 4)) { _ in
                AxisValueLabel(format: .dateTime.hour())
                AxisGridLine()
            }
        case "W":
            // عرض اسم اليوم (S, M, T...) لكل يوم في الأسبوع
            AxisMarks(values: .stride(by: .day, count: 1)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.narrow))
                AxisGridLine()
            }
        case "M":
            // عرض رقم اليوم (5, 10, 15...) لكل شهر
            AxisMarks(values: .stride(by: .day, count: 5)) { _ in
                AxisValueLabel(format: .dateTime.day())
                AxisGridLine()
            }
        case "Y":
            // عرض الحرف الأول من الشهر (J, F, M...) لكل سنة
            AxisMarks(values: .stride(by: .month, count: 1)) { _ in
                AxisValueLabel(format: .dateTime.month(.narrow))
                AxisGridLine()
            }
        default:
            AxisMarks()
        }
    }

    private func getVisibleLength() -> Double {
        let day: Double = 3600 * 24
        switch viewModel.selectedTimeRange {
        case "D":
            return day // الشاشة تعرض 24 ساعة
        case "W":
            return day * 7 // الشاشة تعرض 7 أيام (يظهر كل يوم بوضوح)
        case "M":
            return day * 30 // الشاشة تعرض شهر
        case "Y":
            return day * 365 // الشاشة تعرض سنة كاملة
        default:
            return day * 7
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
            // يعرض: 11 February 2026
            formatter.dateFormat = "d MMMM yyyy"
            return formatter.string(from: date)
            
        case "W":
            // يعرض نطاق الأسبوع: 8 Feb - 14 Feb
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            
            formatter.dateFormat = "d MMM"
            let startStr = formatter.string(from: startOfWeek)
            let endStr = formatter.string(from: endOfWeek)
            
            formatter.dateFormat = "yyyy"
            let yearStr = formatter.string(from: endOfWeek)
            
            return "\(startStr) - \(endStr), \(yearStr)"
            
        case "M":
            // يعرض الشهر والسنة: February 2026
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
            
        case "Y":
            // يعرض السنة فقط: 2026
            formatter.dateFormat = "yyyy"
            return formatter.string(from: date)
            
        default:
            return ""
        }
    }
}
#Preview {
    HomeView()
}
