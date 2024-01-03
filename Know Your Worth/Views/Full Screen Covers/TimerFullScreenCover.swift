//
//  TimerFullScreenCover.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import SwiftUI
import SwiftData

struct TimerFullScreenCover: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) var scenePhase
    
    @Bindable var timeSheet: TimeSheet
    
    @Environment(\.dismiss) var dismiss

    @State var firstTime = true
    @State var isTimerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var isSubmitted = false
    
    
    @State var time: Double = 0.0
    @State var rate: Double = 0.0
    @State var total: Double = 0.0
    
    @State var inActiveTime: Date? = nil
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.appColor)
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Text("TIME TRACKER")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Divider()
                    .overlay(.white)
                    .frame(maxWidth: 150)
                
                
                Spacer()
                
                //Timer
                Text("\(time.timeFormattedString())")
                    .foregroundStyle(isTimerRunning ? Color.red.opacity(0.8) : Color.white.opacity(0.5))
                
                //Rate row
                HStack {
                    Image(systemName: "arrow.down")
                        .fontWeight(.black)
                        .frame(width:50, height: 50)
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                        .onTapGesture {
                            rate -= 0.25
                            totalEarned()
                        }
                    
                    Text("\(rate.toCurrency())")
                        .frame(width: 150, height: 75)
                        .font(.title.bold())
                        .padding(.horizontal)
                        .foregroundStyle(.white)
                    
                    
                    Image(systemName: "arrow.up")
                        .fontWeight(.black)
                        .frame(width:50, height: 50)
                        .background(.green)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                        .onTapGesture {
                            rate += 0.25
                            totalEarned()
                        }
                    
                }
                
                //Current Total
                Text("\(total.toCurrency())")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.green)
                    .padding()
                
                
                
                //Button Row
                HStack {
                    Button {
                        firstTime = false
                        isTimerRunning.toggle()
                    } label: {
                        Text(isTimerRunning ? "Pause" : "Start")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 44)
                            .foregroundStyle(isTimerRunning ? Color.white : Color.green)
                            .background(Color(isTimerRunning ? Color.red : Color.green))
                            .cornerRadius(5)
                            .padding(.horizontal)
                            .shadow(radius: 3)
                    }
                    
                    
                    Button("Update") {
                        submitTimeSheet()
                        
                    }
                    .foregroundColor(.white)
                    .frame(width: 100, height: 44)
                    .background(.blue)
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .shadow(radius: 3)
                    
                }
                .onReceive(timer) { _ in
                    if isTimerRunning == true {
                        time += 1
                        totalEarned()
                    }
                }
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        if let inActiveTime = inActiveTime, !isTimerRunning {
                            let currentTime = Date.now
                            let backgroundTimeDifference = currentTime.timeIntervalSince(inActiveTime)
                            time += backgroundTimeDifference
                            isTimerRunning = true
                            resetInActiveTime()
                        }
                    case .inactive, .background:
                        guard isTimerRunning else { return }
                        inActiveTime = Date.now
                        isTimerRunning = false
                    default:
                        break
                    }
                }
                Spacer()
            }
            .onAppear {
                // Initialize rate, time, and total from timeSheet
                rate = timeSheet.rate
                time = (timeSheet.time * 60 * 60)
                total = timeSheet.total
                totalEarned()
            }
        }
        
    }
    
    func resetInActiveTime() {
        inActiveTime = nil
    }
    func submitTimeSheet() {
        // update current timeSheet
        
        timeSheet.rate = rate
        timeSheet.time = (time / 60 / 60)
        timeSheet.total = total
        
        dismiss()
        
    }
    func totalEarned() {
        let totalEarned = ((time * rate) / 60) / 60
        
        total = totalEarned
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TimeSheet.self, configurations: config)
        let example = TimeSheet(sheetName: "Example TimeSheet", sheetDescription: "This is a short description that will help to show what a description will look like on the form.")
        return TimerFullScreenCover(timeSheet: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create Model Container.")
    }
}
