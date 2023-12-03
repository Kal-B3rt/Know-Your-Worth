//
//  OpenItemCard.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 12/2/23.
//

import SwiftUI
import SwiftData

struct OpenItemCard: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var presentTimer = false
    @State private var presentEdit = false
    
    let timeSheet: TimeSheet
    
    
    var body: some View {
        ZStack() {
            Rectangle()
                .cornerRadius(10.0)
                .foregroundStyle(.white.opacity(0.1))
            
            VStack(alignment: .leading){
                Text(timeSheet.sheetName + "\n")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding([.top, .bottom, .leading])
                    .lineLimit(2)
                
                HStack{
                    VStack{
                        Text("Rate:")
                            .opacity(0.5)
                        Text("\(timeSheet.rate.toCurrency())")
                            .fontWeight(.bold)
                    }
                    Spacer()
                    VStack{
                        Text("Time:")
                            .opacity(0.5)
                        Text("\(timeSheet.time, specifier: "%.2f")")
                            .fontWeight(.bold)
                    }
                    .padding(.trailing, 5)
        
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
    
                HStack{
                    Spacer()
                    Text("\(timeSheet.total.toCurrency())")
                        .foregroundStyle(Color.appGreenSecondary)
                        .font(.title2.bold())
                    Spacer()
                }
                
                HStack{
                    ZStack{
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundStyle(Color.appGreenSecondary)
                        Text("RESUME")
                            .foregroundStyle(.white)
                            .fontWeight(.heavy)
                            .onTapGesture {
                                presentTimer = true
                            }
                    }
                    
                    
                    Spacer()
                    
                    ZStack{
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundStyle(.orange)
                        Text("EDIT")
                            .foregroundStyle(.white)
                            .fontWeight(.heavy)
                            .onTapGesture {
                                presentEdit = true
                            }
                    }
                }
                .frame(width: 200, height: 45)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .frame(width: 200, height: 250)
        
        .fullScreenCover(isPresented: $presentTimer) {
                TimerFullScreenCover(timeSheet: timeSheet)
        }
        .fullScreenCover(isPresented: $presentEdit) {
                EditSheetCoverView(timeSheet: timeSheet)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TimeSheet.self, configurations: config)
        let example = TimeSheet(sheetName: "TimeSheet", sheetDescription: "This is a short description that will help to show what a description will look like on the form.", total: 45, rate: 30, time: 1.5)
        return OpenItemCard(timeSheet: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create Model Container.")
    }

}
