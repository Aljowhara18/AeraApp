//
//  HomeModel.swift
//  BurnexApp

import SwiftUI
import Combine
class HomeViewModel: ObservableObject {
    @Published var stats: [StatModel] = [
        StatModel(title: "RHR", value: "Loading..."),
        StatModel(title: "Sleep", value: "Loading..."),
        StatModel(title: "HRV", value: "Loading...")
    ]
    
    private let healthManager = HealthManager()
    
    init() {
        fetchAllHealthData()
    }
    
    func fetchAllHealthData() {
        healthManager.requestAuthorization { success in
            if success {
                self.healthManager.fetchLatestRHR { value in
                    DispatchQueue.main.async { self.stats[0].value = value }
                }
                self.healthManager.fetchSleep { value in
                    DispatchQueue.main.async { self.stats[1].value = value }
                }
                self.healthManager.fetchLatestHRV { value in
                    DispatchQueue.main.async { self.stats[2].value = value }
                }
            }
        }
    }
    
    func flipCard(at index: Int) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            stats[index].isFlipped.toggle()
        }
    }
}
