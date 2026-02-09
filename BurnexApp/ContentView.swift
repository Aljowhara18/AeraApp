//
//  ContentView.swift
//  BurnexApp
//
//  Created by Jojo on 07/02/2026.
//

import SwiftUI


struct ContentView: View {
    @State private var selectedTab = 1
    var body: some View {
        NavigationStack{
            ZStack{
                Image("BackgroundApp")
                    .resizable()
                    .frame(width: .infinity,height: .infinity)
                    .ignoresSafeArea()
                
                VStack{
                    
                    
                    
                    
                    
                }
            }//z
            .navigationTitle("Analysis")

        }//nav
        
    
    }
}

#Preview {
    ContentView()
}
