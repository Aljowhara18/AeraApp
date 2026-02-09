//
//  AnalysisView.swift
//  BurnexApp
//
//  Created by Hadeel Alansari on 09/02/2026.
//

import SwiftUI
import Charts

struct SleepDataPoint: Identifiable {
    var id = UUID().uuidString
    var day: String
    var hours: Int
}

struct AnalysisView: View {

    @State private var selected = "D"
    let timeRange = ["D", "W", "M", "Y"]

    let analysisOptions = ["All", "Sleep", "HRV", "RHR"]
    @State private var selectedOption = "All"

    let data = [
        SleepDataPoint(day: "SUN", hours: 10),
        SleepDataPoint(day: "MON", hours: 7),
        SleepDataPoint(day: "TUE", hours: 9),
        SleepDataPoint(day: "WED", hours: 8),
        SleepDataPoint(day: "THU", hours: 6),
        SleepDataPoint(day: "FRI", hours: 9),
        SleepDataPoint(day: "SAT", hours: 7)
    ]

    var body: some View {
        NavigationStack {
            ZStack {

                // MARK: - Background
                Image("BackgroundApp")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    
                    // MARK: - Date Picker
                    Picker("", selection: $selected) {
                        ForEach(timeRange, id: \.self) { range in
                            Text(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 350)

                    Spacer().frame(height: 30)

                    // MARK: - Chart Card
                    ZStack(alignment: .bottom) {

                        Rectangle()
                            .fill(.gray.opacity(0.25))
                            .frame(width: 350, height: 270)
                            .cornerRadius(20)

                        Chart {
                            ForEach(data) { d in
                                LineMark(
                                    x: .value("Day", d.day),
                                    y: .value("Hours", d.hours)
                                )
                                .annotation {
                                    ZStack {
                                        Capsule()
                                            .fill(.white)
                                            .frame(width: 36, height: 22)

                                        Text("\(d.hours)")
                                            .font(.system(size: 10))
                                            .foregroundStyle(.black)
                                    }//z
                                }
                            }
                        }//chart
                        .frame(width: 333, height: 200)
                        .padding(.bottom, 12)

                        // MARK: - Analysis Picker
                        ZStack {
                            Capsule()
                                .fill(.black)

                            Picker("", selection: $selectedOption) {
                                ForEach(analysisOptions, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .tint(.white)
                        }//z
                        .frame(width: 98, height: 28)
                        .padding(.bottom, 225)
                        .padding(.leading, -165)
                    }//z

                    Spacer().frame(height: 32)

                    // MARK: - Summary
                    summaryView(title: "HRV", status: "Great")
                    Spacer().frame(height: 32)

                    summaryView(title: "RHR", status: "Normal")
                    Spacer().frame(height: 32)

                    summaryView(title: "Sleep", status: "Low")

                    Spacer()
                }//vMain
                .padding()
                .offset(y: -20)
            }//z
            .navigationTitle("Analysis")
            
        }//nav
    }

    // MARK: - Reusable Summary View
    @ViewBuilder
    private func summaryView(title: String, status: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(.gray)

            HStack {
                Text(status)
                    .font(.system(size: 25, weight: .medium))

                Text("44.2% then last week")
                    .font(.system(size: 14))
                    .foregroundStyle(.blue)
                    .padding(.top, 10)
            }//h
        }//v
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AnalysisView()
}
