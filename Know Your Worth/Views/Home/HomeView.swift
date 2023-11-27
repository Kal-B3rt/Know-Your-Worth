//
//  HomeView.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import SwiftUI


struct HomeView: View {
    
    @State var selectedTab: TabEnum = .dashboard
    
    var body: some View {
        
        TabView(selection: $selectedTab){
            dashboard()
                .tabItem { Label("Dashboard", systemImage: "chart.bar") }
                .tag(TabEnum.dashboard)
            
            
            TimeTrackerView(tag: $selectedTab)
                .tabItem { Label("New Timer", systemImage: "clock") }
                .tag(TabEnum.newTimer)
            
            
            TimeSheetList()
                .tabItem { Label("Time Sheets", systemImage: "list.dash") }
                .tag(TabEnum.listView)
            
            
        }
    }
}

#Preview {
    HomeView()
}
