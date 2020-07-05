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
    
    var body: some View {
        let now = Date()
        let tomorrow = Date().addingTimeInterval(86400)
        let range = now ... tomorrow
        
        return DatePicker("Please enter a date", selection: $wakeUp, in: range, displayedComponents: .hourAndMinute)
            .labelsHidden()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
