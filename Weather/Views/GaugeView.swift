//
//  GaugeView.swift
//  Weather
//
//  Created by Mark Darby on 26/08/2025.
//

import SwiftUI

struct GaugeView: View {
    @State private var batteryLevel = 0.4
    
    @State private var current = 77.0
    @State private var minValue = 50.0
    @State private var maxValue = 170.0
    
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
    
    var body: some View {
        ScrollView {
            // Simple gauge
            Gauge(value: batteryLevel) {
                Text("Battery Level")
            }
            .padding()
            // Labeled gauge
            Gauge(value: current, in: minValue...maxValue) {
                Text("BPM")
            } currentValueLabel: {
                Text("\(Int(current))")
            } minimumValueLabel: {
                Text("\(Int(minValue))")
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
            }
            .padding()
            // Gauge style Circular
            Gauge(value: current, in: minValue...maxValue) {
                Text("BPM")
            } currentValueLabel: {
                Text("\(Int(current))")
            } minimumValueLabel: {
                Text("\(Int(minValue))")
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
            }
            .padding()
            .gaugeStyle(.accessoryCircular)
            
            // Gauge style Circular coloured
            Gauge(value: current, in: minValue...maxValue) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            } currentValueLabel: {
                Text("\(Int(current))")
                    .foregroundColor(Color.green)
            } minimumValueLabel: {
                Text("\(Int(minValue))")
                    .foregroundColor(Color.green)
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
                    .foregroundColor(Color.red)
            }
            .padding()
            // Apple's example but is not available in iOS. .accessoryCircular looks the same.
            //.gaugeStyle(.circular)
            .gaugeStyle(.accessoryCircular)
            
            Gauge(value: current, in: minValue...maxValue) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            } currentValueLabel: {
                Text("\(Int(current))")
                    .foregroundColor(Color.green)
            } minimumValueLabel: {
                Text("\(Int(minValue))")
                    .foregroundColor(Color.green)
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
                    .foregroundColor(Color.red)
            }
            .padding()
            // Apple's example not available in iOS
            //.gaugeStyle(CircularGaugeStyle(tint: gradient))
            .gaugeStyle(.accessoryCircular)//
            .tint(gradient)
            Divider()
            // My experiments
            Gauge(value: current, in: minValue...maxValue) {
//                Image(systemName: "heart.fill")
//                    .foregroundColor(.red)
            } currentValueLabel: {
                Text("\(Int(current))")
                    .foregroundColor(Color.green)
            } minimumValueLabel: {
                Text("")
                    .foregroundColor(Color.green)
            } maximumValueLabel: {
                Text("")
                    .foregroundColor(Color.red)
            }
            .padding()
            .gaugeStyle(.accessoryLinear)
            .tint(gradient)
            
            
            // Code completion 1
            Gauge(value: current) {
                Text("Hello")
            }
            .padding()
            // Code completion 2
            Gauge(value: current, in: minValue...maxValue) {
                Text("Hello 2")
            }
            .gaugeStyle(.accessoryLinear)
            .padding()
            
            // Code completion 3
            Gauge(value: current) {
                Text("Hello 3")
            } currentValueLabel: {
                Text("\(Int(current))")
            }
            .padding()
            
        }
    }
}

#Preview {
    GaugeView()
}
