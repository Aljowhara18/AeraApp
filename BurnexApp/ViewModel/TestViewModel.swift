//
//  TestViewModel.swift
//  BurnexApp
//
//  Created by Jojo on 10/02/2026.
//


import SwiftUI
import Combine
class TestViewModel: ObservableObject {
    @Published var reflections: [ReflectionModel] = []
    
    // ✅ متغيرات جديدة للتحكم في الحذف والتنبيه
    @Published var showDeleteAlert = false
    @Published var itemToDelete: ReflectionModel? = nil
    
    func addReflection(title: String, content: String) {
        // لن نقوم بإضافة كارد إلا إذا كان العنوان يحتوي على نص فعلي
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        if !trimmedTitle.isEmpty {
            let newReflection = ReflectionModel(title: trimmedTitle, content: content)
            withAnimation(.spring()) {
                reflections.insert(newReflection, at: 0)
            }
        }
    }
    
    func deleteReflection(id: UUID) {
        withAnimation(.spring()) {
            reflections.removeAll(where: { $0.id == id })
        }
    }
    
    // باقي الدوال (toggleCard, closeCard) تبقى كما هي...

    func toggleCard(id: UUID) {
        if let index = reflections.firstIndex(where: { $0.id == id }) {
            if !reflections[index].isExpanded {
                withAnimation(.spring()) {
                    reflections[index].isExpanded = true
                }
            } else {
                withAnimation(.spring()) {
                    reflections[index].isFlipped.toggle()
                }
            }
        }
    }
    
    func closeCard(id: UUID) {
        if let index = reflections.firstIndex(where: { $0.id == id }) {
            withAnimation(.spring()) {
                reflections[index].isExpanded = false
                reflections[index].isFlipped = false
            }
        }
    }
}
