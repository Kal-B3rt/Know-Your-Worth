//
//  TimeTrackerView.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import SwiftUI
import SwiftData

struct TimeTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var tag: TabEnum

    @State var animateUp = false
    @State var animateDown = false
    
    @State var firstTime = true
    @State var isTimerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var time: Double = 0.0
    @State var rate = 25.00
    @State var total = 0.00
    
    @State var inActiveTime: Date? = nil
    
    var body: some View {
        
            NavigationStack{
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
                        
                        
                        Button("Submit") {
                            submitTimeSheet()
                            resetPage()
                        }
                        .disabled(isTimerRunning || firstTime == true )
                        .foregroundColor(.white)
                        .frame(width: 100, height: 44)
                        .background(Color(isTimerRunning || firstTime == true ? Color.gray : Color.blue))
                        .cornerRadius(5)
                        .padding(.horizontal)
                        .shadow(radius: 3)
                        
                    }
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button(action: {resetPage()}, label: {
                                Label("Add Item", systemImage: "arrow.counterclockwise")
                                
                            })
                        }
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
                
            }
        }
    }
    
    private func resetInActiveTime() {
        inActiveTime = nil
    }
    
    func submitTimeSheet() {
        
        let convertedTime = time.convertToHoursRounded()
        
        let newTimeSheet = TimeSheet(sheetName: "New Time Sheet", sheetDescription: "New Time Sheet Description", total: total, rate: rate, time: convertedTime, creationDate: .now, completed: false)
            modelContext.insert(newTimeSheet)
            tag = .listView
            
        
    }
               
        func totalEarned() {
            let totalEarned = ((time * rate) / 60) / 60
            
            total = totalEarned
        }
        
        func resetPage() {
            time = 0.0
            rate = 30.00
            total = 0.00
            firstTime = true
        }
    }

    
    #Preview {
        TimeTrackerView(tag: .constant(TabEnum.newTimer))
    }
