//
//  ContentView.swift
//  SwiftUIBetterRest
//
//  Created by Richard Price on 31/01/2022.
//
import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = wakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var wakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("please select a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                } header: {
                    Text("when do you want to wake up?")
                       
                }
                
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("desired sleep amont")
                        
                }
                
                Section {
                    Picker("Number of Cups", selection: $coffeeAmount) {
                        ForEach(1..<12) {
                            Text(String($0))
                        }
                    }
                } header: {
                    Text("Coffee Amount")
                }
                
                Section {
                    Picker("more cups", selection: $coffeeAmount) {
                        ForEach(1..<5) {
                            Text(String($0))
                        }
                    }
                }

            }.navigationTitle("Better Rest")
                .toolbar {
                    Button("Calculate", action: calculateBedtime)
                }
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK") { }
                } message: {
                    Text(alertMessage)
                }
        }
    }
    
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount ))
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal sleep time is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calcuating your bedtime"
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
