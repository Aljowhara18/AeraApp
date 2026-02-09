//
//  Home.swift
//  BurnexApp

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var stats: [StatModel] = [
        StatModel(title: "Heartbeats", value: "82 BPM"),
        StatModel(title: "Sleep", value: "85%"),
        StatModel(title: "Steps", value: "6,400"),
        StatModel(title: "Stress", value: "Low")
    ]
    
    func flipCard(at index: Int) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            stats[index].isFlipped.toggle()
        }
    }
}
