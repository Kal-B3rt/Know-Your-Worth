//
//  TimeSheetRowView.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import SwiftUI
import SwiftData

struct TimeSheetRowView: View {
    @Environment(\.modelContext) private var modelContext
    
    let timeSheet: TimeSheet
    
    var body: some View {
            HStack {
                if timeSheet.completed == true {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                }
                VStack(alignment: .leading) {
                    Text(timeSheet.sheetName)
                        .foregroundStyle(.primary)
                    Text("\(timeSheet.creationDate, style: .date)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(timeSheet.total.toCurrency())
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TimeSheet.self, configurations: config)
        let example = TimeSheet(sheetName: "Example TimeSheet", sheetDescription: "This is a short description that will help to show what a description will look like on the form.", total: Double.random(in: 43...67))
        return TimeSheetRowView(timeSheet: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create Model Container.")
    }
}
