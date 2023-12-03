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
                    .foregroundStyle(.white)
                
                Text("Past Week")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                
                
                ChartView()
                    .frame(height: 150)
                    .padding()
                    .foregroundStyle(Color.appGreenSecondary)
                

                Divider()
                    .overlay(.white)
                    .frame(height: 10)
                
                
                OpenItemList()
                
                
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
