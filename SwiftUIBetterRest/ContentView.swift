//
//  ContentView.swift
//  SwiftUIBetterRest
//
//  Created by Richard Price on 31/01/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("when do you want to wake up?")
                    .font(.headline)
                
                DatePicker("please select a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("desired sleep amont")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Stepper(coffeeAmount == 1 ? "1 Cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
            }.navigationTitle("Better Rest")
                .toolbar {
                    Button("Calculate", action: calculateBedtime)
                }
        }
    }
    
    
    func calculateBedtime() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
