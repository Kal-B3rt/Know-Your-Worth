//
//  OpenItemList.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 12/2/23.
//

import SwiftUI
import SwiftData

struct OpenItemList: View {
    
    @Query(filter: #Predicate {!$0.completed},sort: \TimeSheet.creationDate, order: .forward) var notCompletedSheet: [TimeSheet]
    
    var body: some View {
        if notCompletedSheet.isEmpty {
            ZStack(){
                Rectangle()
                    .foregroundStyle(Color.appColor)
                    .ignoresSafeArea()
                
                Text("No Open Time Sheets" + "\n" + "Let's Get To Work!")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        else {
            VStack{
                HStack{
                    Text("Not Completed")
                        .font(.largeTitle)
                        .foregroundStyle(.white.opacity(0.7))
                }
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(notCompletedSheet) { timesheet in
                            OpenItemCard(timeSheet: timesheet)
                            .frame(width: 225, height: 275)
                            .padding()
                        }
                    }
                }
            }
            
        }
        
    }
}

#Preview {
    OpenItemList()
}
