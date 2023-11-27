//
//  ChartViewModel.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import Foundation
import SwiftData

@Observable class ChartViewModel {
    
    
    var modelContext: ModelContext? = nil
    var sheets = [TimeSheet]()
    
    var sevenDayTotal: Double {
        sheets.reduce(0) { $0 + $1.total}
    }
    
    //This is what the chart actually reads. It first groups the Timesheets by day using an Int, then it sums the totals of the time sheets. So that it can easily be read in a chart. Finally, it sorts the time sheets so that it returns the weekday from Sunday to Saturday.
    var earnedByWeekDay: [(number: Int, earned: Double)] {
        let groupByDay = sheetsGroupedByWeekday(sheet: sheets)
        let totalEarned = weekdayTotal(earnedByNumber: groupByDay)
        let sorted = sorted(weekTotal: totalEarned)
        return sorted
    }
    
    //Creates a variable that holds dictionary of timesheets with their weekday. Weekday is stored as an Int so that we can read it out better on a chart.
    var sheetByWeekDay: [(number: Int, sheet: [TimeSheet])] {
        let totalByWeekDay = sheetsGroupedByWeekday(sheet: sheets).map {
            (number: $0.key, sheet: $0.value)
        }
        
        return totalByWeekDay.sorted { $0.number < $1.number }
    }
    
    //Creates a fetch request that is initalized when the chartview appears. Right now it fetches ALL timesheets then filters out anything that is not from the previous 7 days. This needs to be improved. So that a predicate of 7 days is built in.
    func fetchData() {
        let fetchDescriptor = FetchDescriptor<TimeSheet> (
            predicate: #Predicate {
                $0.completed
            },
            sortBy: [SortDescriptor(\.sheetName)]
        )
        
        sheets = (try? (modelContext?.fetch(fetchDescriptor) ?? [])) ?? []
        
        // Calculate the date 7 days ago
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        // Filter the sheets to only keep those from the past 7 days
        sheets = sheets.filter { $0.creationDate >= sevenDaysAgo }
    }
    
    
    //Groups timesheets together by an array. Returns a Dictionary.
    func sheetsGroupedByWeekday(sheet: [TimeSheet]) -> [Int: [TimeSheet]] {
        var sheetsByWeekday: [Int: [TimeSheet]] = [:]
        let calendar = Calendar.current
        
        for sheet in sheets {
            let weekday = calendar.component(.weekday, from: sheet.creationDate)
            if sheetsByWeekday[weekday] != nil {
                sheetsByWeekday[weekday]!.append(sheet)
            } else {
                sheetsByWeekday[weekday] = [sheet]
            }
        }
        // print("Debug: Weekday Sheets -> \(sheetsByWeekday)")
        return sheetsByWeekday
    }
    
    
    // Takes the sheets that have been grouped by day and returns a Dictionary that has a day as an Int and an Earned as the total of all the sheets under that day.
    func weekdayTotal(earnedByNumber: [Int: [TimeSheet]]) -> [(number: Int, earned: Double)] {
        // Manually creating each day of the week.
        var totalEarned: [(number: Int, earned: Double)] = [(1, 0.0), (2, 0.0), (3, 0.0), (4, 0.0), (5, 0.0), (6, 0.0), (7, 0.0)]
        
        for (number, earned) in earnedByNumber {
            let totalEarnedWeekday = earned.reduce(0) { $0 + $1.total }
            
            // Find the index of the day of the week in the array
            if let index = totalEarned.firstIndex(where: { $0.number == number }) {
                // Update the existing entry for the day
                totalEarned[index].earned = Double(totalEarnedWeekday)
            }
        }
        
        print("Debug: \(totalEarned)")
        return totalEarned
    }
    
    
    
    func sorted(weekTotal: [(number: Int, earned: Double)]) -> [(number: Int, earned: Double)] {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())
        
        var days = Array(1...7)
        
        // Rearrange the days based on the current day
        for _ in 1..<today {
            if let first = days.first {
                days.removeFirst()
                days.append(first)
            }
        }
        
        // Sort the array based on the reordered days
        let sortedWeek = weekTotal.sorted { (a, b) in
            return days.firstIndex(of: a.number)! < days.firstIndex(of: b.number)!
        }
        
        // Move the first tuple to the end
        var modifiedSortedWeek = sortedWeek
        if let firstTuple = modifiedSortedWeek.first {
            modifiedSortedWeek.removeFirst()
            modifiedSortedWeek.append(firstTuple)
        }
        
        return modifiedSortedWeek
        
    }
    
    
    static var preview: ChartViewModel {
        let vm = ChartViewModel()
        vm.sheets = TimeSheet.threeMonthExample()
        return vm
    }
    
    
}
