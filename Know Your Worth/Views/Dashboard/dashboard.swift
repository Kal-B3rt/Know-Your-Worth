//
//  dashboard.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import SwiftUI
import SwiftData

struct dashboard: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.appColor)
                        .ignoresSafeArea()
            
            VStack(alignment: .center){
                
                Text("DASHBOARD")
                    .fontWeight(.bold)
                    .font(.title)
                
                Text("Past Week")
                    .font(.caption)
                
                
                ChartView()
                    .frame(height: 150)
                    .padding()
                

                
                Divider()
                
                
                Spacer()
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TimeSheet.self, configurations: config)
        return dashboard()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create Model Container.")
    }
}
