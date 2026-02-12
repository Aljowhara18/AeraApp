//
//  AnalysisView.swift
//  BurnexApp
//
//  Created by Hadeel Alansari on 11/02/2026.
//

import SwiftUI
import Charts

struct AnalysisView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    let chartColors: KeyValuePairs<String, Color> = ["Sleep": .blue, "HRV": .purple, "RHR": .orange]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                //MARK: - Background
                
                       Image("Background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .ignoresSafeArea()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                
                Color.black.opacity(0.3).ignoresSafeArea()
                
                //MARK: - Chart Rectangle
                
                VStack(alignment: .leading, spacing: 0) {
                    headerView
                    pickerView
                        .padding(.top, 16)

                    ZStack(alignment: .topTrailing) {
                        
                        //Rectangle
                        VStack(alignment: .leading, spacing: 5) {
                            dateHeader
                            mainChartView(height: geometry.size.height * 0.32)
                                //.padding(.bottom, 15)
                        }
                        .padding(.bottom,16)
                        .glassEffect(in: .rect(cornerRadius: 24))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        
                        
                        //Picker
                        filterMenu
                            .padding(.top, 12)
                            .padding(.trailing, 20)
                            .zIndex(1) // مهم عشان يطلع فوق
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
              


                    //MARK: - Summary
                    
                    VStack(alignment: .leading, spacing: 25) {
                        if viewModel.selectedOption == "All" || viewModel.selectedOption == "HRV" {
                            summaryRow(title: "HRV")
                        }
                        if viewModel.selectedOption == "All" || viewModel.selectedOption == "RHR" {
                            summaryRow(title: "RHR")
                        }
                        if viewModel.selectedOption == "All" || viewModel.selectedOption == "Sleep" {
                            summaryRow(title: "Sleep")
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 25).padding(.top, 25)
                    .animation(.easeInOut, value: viewModel.selectedOption)
                }
            }
        }
        .onAppear { viewModel.fetchChartData() }
    }
}


// MARK: - View Components
extension AnalysisView {
    private var headerView: some View {
        Text("Analysis").font(.system(size: 34, weight: .bold)).foregroundColor(.white).padding(.horizontal, 20).padding(.top, 60)
    }

    private var pickerView: some View {
        Picker("", selection: $viewModel.selectedTimeRange) {
            ForEach(["D", "W", "M", "Y"], id: \.self) { Text($0).tag($0) }
        }
        .pickerStyle(.segmented)
        .background(.black)
        .cornerRadius(100)
        .glassEffect(in: .rect(cornerRadius: 100))
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
            .foregroundStyle(.white)
            .frame(width: 95,height: 26)
            .font(.system(size: 14))
            .glassEffect(in:.rect(cornerRadius: 20))
        }
    }

    private func mainChartView(height: CGFloat) -> some View {
        Chart {
            ForEach(viewModel.chartData) { d in
                LineMark(x: .value("Date", d.date, unit: getUnit()), y: .value("Value", d.value))
                    .foregroundStyle(by: .value("Type", d.type))
                    .interpolationMethod(.catmullRom).lineStyle(StrokeStyle(lineWidth: 3))

                if viewModel.selectedTimeRange != "Y" {
                    PointMark(x: .value("Date", d.date, unit: getUnit()), y: .value("Value", d.value))
                        .foregroundStyle(by: .value("Type", d.type)).symbolSize(30)
                }
                AreaMark(x: .value("Date", d.date, unit: getUnit()), y: .value("Value", d.value))
                    .foregroundStyle(by: .value("Type", d.type)).opacity(0.1)
            }
        }
        .chartForegroundStyleScale(chartColors)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: getVisibleLength())
        .chartScrollPosition(initialX: Date())
        .chartScrollPosition(x: $viewModel.scrollPosition)
        .chartXAxis { configureXAxis() }
        .chartYAxis { AxisMarks(position: .leading) }
        .frame(height: height).padding(.horizontal)
    }

    private func summaryRow(title: String) -> some View {
        let data = viewModel.calculateSummary(for: title)
        
        // اللون حسب الحالة
        let textColor: Color = data.state == .noData ? .grayApp : .text2
        
        return VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)

            HStack(alignment: .center, spacing: 8) {
                Text(data.status)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(textColor)

                if data.state != .noData {
                    Text("\(data.percentageText)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
    }


    // Helpers
    private func getUnit() -> Calendar.Component {
        switch viewModel.selectedTimeRange {
        case "D": return .hour
        case "W", "M": return .day
        case "Y": return .month
        default: return .day
        }
    }

    private func getVisibleLength() -> Double {
        let day: Double = 86400
        switch viewModel.selectedTimeRange {
        case "D": return day
        case "W": return day * 7
        case "M": return day * 30
        case "Y": return day * 365
        default: return day * 7
        }
    }

    private var dateHeader: some View {
        Text(getFormattedDate(for: viewModel.scrollPosition)).font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.gray).padding([.top, .leading], 16)
    }

    private func getFormattedDate(for date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        switch viewModel.selectedTimeRange {
        case "D": formatter.dateFormat = "d MMMM yyyy"; return formatter.string(from: date)
        case "W":
            let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            let end = calendar.date(byAdding: .day, value: 6, to: start)!
            formatter.dateFormat = "d MMM"
            return "\(formatter.string(from: start)) - \(formatter.string(from: end)), \(calendar.component(.year, from: end))"
        case "M": formatter.dateFormat = "MMMM yyyy"; return formatter.string(from: date)
        case "Y": formatter.dateFormat = "yyyy"; return formatter.string(from: date)
        default: return ""
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
}

#Preview {
    AnalysisView()
}
