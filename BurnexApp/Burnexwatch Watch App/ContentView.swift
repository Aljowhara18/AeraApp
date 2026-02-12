//
//  ContentView.swift
//  Burnexwatch Watch App
//
//  Created by Faitmh ibrahim on 23/08/1447 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    OverviewWatchView()
}
