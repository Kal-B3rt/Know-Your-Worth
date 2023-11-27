//
//  ChartView.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import SwiftUI
import SwiftData
import Charts

struct ChartView: View {
    @Environment (\.modelContext) var modelConext
    @State var viewModel = ChartViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Chart(viewModel.earnedByWeekDay, id: \.number) {
                BarMark(x: .value("Day", weekday(for: $0.number)),
                        y: .value("Earned", $0.earned))
            }
            
            Text("You've earned \(viewModel.sevenDayTotal.toCurrency()) this week.")
                .bold()
                .padding(.top)
                
        }
        .onAppear {
            viewModel.modelContext = modelConext
            viewModel.fetchData()
        }
    }
    
    let formatter = DateFormatter()
    
    func weekday(for number: Int) -> String {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())
        
        if today == number {
            return "Today".uppercased()
        } else {
            return formatter.shortWeekdaySymbols[number - 1]
        }
    }
}
    
    
    #Preview {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: TimeSheet.self, configurations: config)
            return ChartView(viewModel: ChartViewModel.preview)
                .modelContainer(container)
                .aspectRatio(1, contentMode: .fit)
        } catch {
            fatalError("Failed to create Model Container.")
        }
    }
