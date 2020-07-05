//
//  ContentView.swift
//  BetterRest
//
//  Created by Nate Lee on 7/5/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date()
    
    var body: some View {
        VStack {
            Stepper(value: $sleepAmount, in: 4...12, step: 0.5) {
                Text("\(sleepAmount, specifier: "%.1f")")
            }
            
            DatePicker("Please enter a date", selection: $wakeUp, in: Date()..., displayedComponents: .hourAndMinute)
                .labelsHidden()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
