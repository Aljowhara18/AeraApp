//
//  TestViewModel.swift
//  BurnexApp
//
//  Created by Jojo on 10/02/2026.
//

import SwiftUI
import Combine

class TestViewModel: ObservableObject {
    @Published var reflections: [ReflectionModel] = [
        // بيانات تجريبية مطابقة للصورة
        ReflectionModel(title: "Meetings", content: "There is lot of meetings happens this period and thats why i feel so exhausted"),
        ReflectionModel(title: "Close Out Project", content: "Finalizing the documentation was tough but rewarding.")
    ]
    
    // دالة للتحكم في حالة الكارد
    func toggleCard(id: UUID) {
        if let index = reflections.firstIndex(where: { $0.id == id }) {
            if !reflections[index].isExpanded {
                // إذا لم تكن مكبرة، نكبرها أولاً
                withAnimation(.spring()) {
                    reflections[index].isExpanded = true
                }
            } else {
                // إذا كانت مكبرة، نقلبها لإظهار المحتوى
                withAnimation(.spring()) {
                    reflections[index].isFlipped.toggle()
                }
            }
        }
    }
    
    // دالة لتصغير الكارد عند الضغط خارجها
    func closeCard(id: UUID) {
        if let index = reflections.firstIndex(where: { $0.id == id }) {
            withAnimation(.spring()) {
                reflections[index].isExpanded = false
                reflections[index].isFlipped = false
            }
        }
    }
}
