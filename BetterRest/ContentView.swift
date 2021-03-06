//
//  ContentView.swift
//  BetterRest
//
//  Created by Nate Lee on 7/5/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    static private var defaultWakeTime: Date {
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 30
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    static private var sleepAmountsAtDisposal: [Double] {
        var value = 4.0
        var result = [value]
        
        repeat {
            value += 0.25
            result.append(value)
        } while (value < 12)
        
        print("🎯")
        return result
    }
    
    static private var sleepAmounts = ContentView.sleepAmountsAtDisposal
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmountIndex = 7
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var bedTime: String = "Unknown"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    Picker(selection: $sleepAmountIndex, label: Text("\(sleepAmountIndex) hours")) {
                        ForEach(0 ..< ContentView.sleepAmounts.count) {
                            Text("\(ContentView.sleepAmounts[$0], specifier: "%g") hours")
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                }
                
                Section(header: Text("Daily coffee intake")) {
                    Stepper(value: $coffeeAmount, in: 0...10, step: 1) {
                        Text("\(coffeeAmount) \(coffeeAmount > 1 ? "cups" : "cup")")
                    }
                }
                
                Section(header: Text("Suggestion")) {
                    Text("The estimated bed time is \(calculateBedtime())")
                        .font(.headline)
                }
            }
            .navigationBarTitle("Better Rest")
        }
    }
    
    func calculateBedtime() -> String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: ContentView.sleepAmounts[sleepAmountIndex],
                coffee: Double(coffeeAmount)
            )
            
            let sleepTime = wakeUp - prediction.actualSleep
            let df = DateFormatter()
            df.dateFormat = "h:mm a"
            
            let result = df.string(from: sleepTime)
            return result
            
        } catch {
        }
        
        return "Unknown"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
