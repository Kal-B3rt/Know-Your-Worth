//
//  TimeSheetList.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import SwiftUI
import SwiftData

struct TimeSheetList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate {!$0.completed},sort: \TimeSheet.creationDate, order: .reverse) var notCompletedSheet: [TimeSheet]
    @Query(filter: #Predicate {$0.completed}, sort: \TimeSheet.creationDate, order: .reverse) var completedSheets: [TimeSheet]
    
    @State private var isPresented = false
    @State private var path = [TimeSheet]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("Not Completed") {
                    
                    ForEach(notCompletedSheet) { timesheet in
                        NavigationLink(value: timesheet) {
                            TimeSheetRowView(timeSheet: timesheet)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    if notCompletedSheet.isEmpty {
                        Text("All time sheets have been completed. Start a new one!")
                            .listRowBackground(Color.clear)
                            
                    }
                }
                Section("Marked Complete") {
                    ForEach(completedSheets) { timesheet in
                        NavigationLink(value: timesheet) {
                            TimeSheetRowView(timeSheet: timesheet)
                        }
                    }
                    .onDelete(perform: deleteCompletedItems)
                    
                    
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {addItem()}, label: {
                        Label("Add Item", systemImage: "plus")
                    })
                }
            }
            .sheet(isPresented: $isPresented, content: {
                
            })
            .navigationTitle("Your Time Sheets")
            .navigationDestination(for: TimeSheet.self, destination: EditTimeSheetView.init)
        }
    }
    
    private func addItem() {
        let newTimeSheet = TimeSheet()
        modelContext.insert(newTimeSheet)
        path = [newTimeSheet]
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(notCompletedSheet[index])
            }
        }
    }
    
    private func deleteCompletedItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(completedSheets[index])
            }
        }
    }
}

#Preview {
    TimeSheetList()
        .modelContainer(for: TimeSheet.self, inMemory: true)
}
