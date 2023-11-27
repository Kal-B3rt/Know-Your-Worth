//
//  TimeSheetModel.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import Foundation
import SwiftData

@Model
class TimeSheet: Hashable {
    
    var sheetName: String
    var sheetDescription: String
    var total: Double
    var rate: Double
    var time: Double
    var creationDate: Date
    var completed: Bool
    
    init(sheetName: String = "", sheetDescription: String = "", total: Double = 22.50, rate: Double = 15, time: Double = 1.5, creationDate: Date = Date(), completed: Bool = true) {
        
        self.sheetName = sheetName
        self.sheetDescription = sheetDescription
        self.total = total
        self.rate = rate
        self.time = time
        self.creationDate = creationDate
        self.completed = false
    }
    
    static var example = TimeSheet(sheetName: "Example Time Sheet", sheetDescription: "Description", total: Double.random(in: 40...120), rate: 15, time: 2, creationDate: Date.now, completed: true)
    
    static func threeMonthExample() -> [TimeSheet]{
        let threeMonthsAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        let exampleSheets: [TimeSheet] = (1...15).map { _ in
            let randomTotal = Double.random(in: 25...220)
            let randomDate = Date.random(in: threeMonthsAgo...Date())
            
            return TimeSheet(total: randomTotal, creationDate: randomDate)
        }
        return exampleSheets.sorted { $0.creationDate < $1.creationDate }
    }
    
}
