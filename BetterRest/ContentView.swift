//
//  ContentView.swift
//  BetterRest
//
//  Created by Nate Lee on 7/5/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    static var defaultWakeTime: Date {
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 30
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    static private var sleepAmounts: [Double] {
        return [4.0, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5]
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmountIndex = 7
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
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
            }
            .navigationBarTitle("Better Rest")
            .navigationBarItems(trailing:
                Button(action: calculateBedtime) {
                    Text("Calculate")
                }
            )
                .alert(isPresented: $showingAlert) { () -> Alert in
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: ContentView.sleepAmounts[sleepAmountIndex], coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            let df = DateFormatter()
            df.dateFormat = "h:mm a"
            
            alertTitle = "The estimated bed time is..."
            alertMessage = df.string(from: sleepTime)
            
        } catch(let error) {
            alertTitle = "Error!"
            alertMessage = error.localizedDescription
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
