//
//  MainTabView.swift
//  BurnexApp
//
//  Created by Hadeel Alansari on 12/02/2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                
                HomeView()
                    .tabItem {
                        Image(systemName: "timelapse")
                           
                        Text("Rhythm")
                    }
                    .tag(0)
                
                AnalysisView()
                    .tabItem {
                        Image(systemName: "chart.xyaxis.line")
                          
                        Text("Analysis")
                    }
                    .tag(1)
                
                TestView()
                    .tabItem {
                        Image(systemName: "list.clipboard")

                        Text("Assignment")
                    }
                    .tag(2)
            }
            .tint(.text)

            
        }
    }
}
#Preview {
    MainTabView()
}
