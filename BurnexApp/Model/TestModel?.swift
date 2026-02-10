//
//  TestModel?.swift
//  BurnexApp
//
//  Created by Jojo on 10/02/2026.
//

import Foundation

struct TestModel
: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    var isExpanded: Bool = false // لتكبير الكارد
    var isFlipped: Bool = false  // لقلب الكارد
}
