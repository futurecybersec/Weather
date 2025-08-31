//
//  DailyMeasurement.swift
//  Weather
//
//  Created by Mark Darby on 31/08/2025.
//

import Foundation

struct DailyMeasurement {
    let time: Date
    let minTemperature: Double
    let maxTemperature: Double
    let weatherCode: Int
    let sunrise: Date
    let sunset: Date
    
    var day: String {
        time.formatted(.dateTime.weekday(.abbreviated))
    }
    
    var formattedMinTemperature: String {
        String(Int(minTemperature.rounded()))
    }
    
    var formattedMaxTemperature: String {
        String(Int(maxTemperature.rounded()))
    }
    
    var weatherSymbol: String {
        weatherInterpretationCodes[weatherCode]?[1] ?? "sun.fill.max"
    }
}
