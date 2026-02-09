//
//  HomeModel.swift
//  BurnexApp
//
//  Created by Jojo on 07/02/2026.
import Foundation

struct StatModel: Identifiable {
    let id = UUID()
    let title: String
    var value: String
    var isFlipped: Bool = false
}

