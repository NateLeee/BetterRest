//
//  ContentView.swift
//  BetterRest
//
//  Created by Nate Lee on 7/5/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper(value: $sleepAmount, in: 4...12, step: 0.5) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(value: $coffeeAmount, in: 0...10, step: 1) {
                    Text("\(coffeeAmount) \(coffeeAmount > 1 ? "cups" : "cup")")
                }
                
            }
            .navigationBarTitle("Better Rest")
            .navigationBarItems(trailing:
                Button(action: calculateBedtime) {
                    Text("Calculate")
                }
            )
        }
    }
    
    
    func calculateBedtime() {
        print("calculateBedtime")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
