//
//  EditTimeSheetView.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import SwiftUI
import SwiftData

struct EditTimeSheetView: View {
    
    @Bindable var timeSheet: TimeSheet
    
    @State private var isTimerFullScreenCoverPresented = false
    
    @FocusState private var keyboardFocused: Bool
    
    private var calculatedTotal: Double {
        timeSheet.time * timeSheet.rate
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
            Form{
                Section("The Basics") {
                    TextField("Project Name", text: $timeSheet.sheetName)
                    TextField("Details", text: $timeSheet.sheetDescription, axis: .vertical)

                    DatePicker("Pick a date", selection: $timeSheet.creationDate, displayedComponents: [.date])
                }
                .listRowBackground(Color.white.opacity(0.1))
                .listRowSeparatorTint(.appColor, edges: .bottom)
                
                Section("Rate and Time"){
                    TextField("Rate", value: $timeSheet.rate, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)

                       
                    HStack {
                        Image(systemName: "clock")
                        TextField("", value: $timeSheet.time, format: .number.rounded(rule: .up))
                            .keyboardType(.decimalPad)
                            .onChange(of: calculatedTotal) { _, _ in
                                timeSheet.total = calculatedTotal
                            }
                    }
 
                    Text("Example: 1.5 = 1 hour and 30 minutes")
                        .listRowBackground(Color.clear)
                        .font(.caption)
                        .opacity(0.7)
                    
                }
                .listRowBackground(Color.white.opacity(0.1))
                .listRowSeparatorTint(.appColor, edges: .bottom)
                
                Section("Current Total") {
                    Text("\(calculatedTotal.toCurrency())")
                        .listRowBackground(Color.clear)
                        .font(.title)
                        .foregroundStyle(.green)
                }
                
                Section("TimeSheet Status"){
                    HStack{
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                        Toggle("Is this completed?", isOn: $timeSheet.completed)
                    }
                    if !timeSheet.completed {
                        HStack {
                            Image(systemName: "clock")
                            Button("Continue Timer?") {
                                isTimerFullScreenCoverPresented = true
                            }
                        }
                    }
                    
                }
                .listRowBackground(Color.white.opacity(0.1))
                .listRowSeparatorTint(.appColor, edges: .bottom)
        }
            .scrollContentBackground(.hidden)
            .background(.appBackground)
            .foregroundStyle(.white)
            .toolbar{
                if keyboardFocused == true {
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {keyboardFocused = false}, label: {
                            Text("Done")
                            
                        })
                    }
                }
            }
            .navigationTitle("Edit Time Sheet")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $isTimerFullScreenCoverPresented) {
                TimerFullScreenCover(timeSheet: timeSheet)
            }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TimeSheet.self, configurations: config)
        let example = TimeSheet(sheetName: "Example TimeSheet", sheetDescription: "This is a short description that will help to show what a description will look like on the form.")
        return EditTimeSheetView(timeSheet: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create Model Container.")
    }
    
}
