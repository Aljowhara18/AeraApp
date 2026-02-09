//
//  AnalysisView.swift
//  BurnexApp
//
//  Created by Hadeel Alansari on 09/02/2026.
//

import SwiftUI
import Charts

struct SleepDataPoint: Identifiable{
    var id = UUID().uuidString
    var day: String
    var hours: Int
}

struct AnalysisView: View {
    
    @State private var selected = "D"
    let TimeRange = ["D","W","M","Y"]
    let AnalysisOptions = ["All","Sleep","HRV","RHR"]
    @State private var selected1 = "All"
    @State private var selectedTab = 1
    
    let data = [
        SleepDataPoint(
            day: "SUN", hours: 10),
        SleepDataPoint(
                day: "MON", hours: 7),
        SleepDataPoint(
            day: "TUE", hours: 9),
        SleepDataPoint(
                day: "WED", hours: 8),
        SleepDataPoint(
                day: "THU", hours: 6),
        SleepDataPoint(
            day: "FRI", hours: 9),
        SleepDataPoint(
                day: "SAT", hours: 7)]
    
    var body: some View {
        NavigationStack{
            
            VStack{
                
                //MARK: - DatePicker
                
                Picker("", selection: $selected) {
                    ForEach(TimeRange, id: \.self) { TimeRange in
                        Text(TimeRange)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 350)
                
                Spacer().frame(height: 16)
                
                //MARK: - Chart
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(width: 350, height: 270)
                        .foregroundStyle(.gray)
                        .cornerRadius(20)
                    
                    Chart{
                        
                        ForEach (data) {d in
                            LineMark(x: .value("Day",d.day),
                                     y: .value("hours",d.hours))
                            
                            .annotation{
                                ZStack{
                                    Rectangle()
                                        .frame(width: 36,height: 22)
                                        .cornerRadius(100)
                                    
                                    Text(String(d.hours))
                                        .foregroundStyle(.black)
                                        .font(.system(size: 10))
                                }
                            }
                        }//fore
                        
                    }//chart
                    .frame(width: 333, height: 200)
                    .padding(.bottom, 12)
                    
                    
                    //MARK: - Picker
                    
                    ZStack{
                        Rectangle()
                            .frame(width: 98,height: 28)
                            .cornerRadius(100)
                            .foregroundStyle(.black)
                    
                        
                        Picker("", selection: $selected1) {
                            ForEach(AnalysisOptions, id: \.self) { AnalysisOptions in
                                Text(AnalysisOptions)
                            }
                        }
                        .tint(.white)
                    }//z
                    .padding(.bottom,225)
                    .padding(.leading,-165)
                    
                }//z
                
                    
                Spacer().frame(height: 32)
                
                
                //MARK: - Summary
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("HRV")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                    Spacer().frame(height: -10)
                    
                    HStack{
                        Text("Great")
                            .font(.system(size: 25,weight: .medium))
                        
                        Text("44.2% then last week")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                            .padding(.top,10)
                    }//h
                }//v
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 32)
               
                VStack(alignment: .leading, spacing: 2) {
                    Text("RHR")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                    Spacer().frame(height: -10)
                    
                    HStack{
                        Text("Normal")
                            .font(.system(size: 25,weight: .medium))
                        
                        Text("44.2% then last week")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                            .padding(.top,10)
                    }//h
                }//v
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sleep")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                    Spacer().frame(height: -10)
                    
                    HStack{
                        Text("Low")
                            .font(.system(size: 25,weight: .medium))
                        
                        Text("44.2% then last week")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                            .padding(.top,10)
                    }//h
                }//v
                .frame(maxWidth: .infinity, alignment: .leading)
                    
                
                
                }//vM
                .navigationTitle("Analysis")
                .padding()
            
            TabView(selection: $selectedTab) {
                Image("").tabItem { Text("Tab Label 1") }.tag(1)
                Text("").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
                Text("").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(3)
            }
            }//nav
        }
    }


#Preview {
    AnalysisView()
}

