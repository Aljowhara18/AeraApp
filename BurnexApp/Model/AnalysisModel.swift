//
//  AnalysisModel.swift
//  BurnexApp
//
//  Created by Hadeel Alansari on 11/02/2026.
//

import SwiftUI

// MARK: - Health Models

struct HealthDataPoint: Identifiable {
    let id = UUID()
    var date: Date
    var value: Double
    var type: String // HRV, RHR, Sleep
}

struct SummaryData {
    var status: String = "No Data"
    var percentageText: String = ""
    var state: ComparisonState = .noData
    
    enum ComparisonState {
        case great, normal, low, noData
        
        var color: Color {
            switch self {
            case .great, .normal, .low: return .white
            case .noData: return .gray
            }
        }
    }
}
