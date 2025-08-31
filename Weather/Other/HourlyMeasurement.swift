//
//  HourlyMeasurement.swift
//  Weather
//
//  Created by Mark Darby on 31/08/2025.
//

import Foundation

struct HourlyMeasurement {
    let time: Date
    let temperature: Double
    let weatherCode: Int
    let isDay: Bool
    
    // Only display the hour 24 format
    var formattedTime: String {
        time.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)))
    }
    
    var formattedTemperature: String {
        String(Int(temperature.rounded())) + "º"
    }
    
    var weatherSymbol: String {
        if isDay {
            weatherInterpretationCodes[weatherCode]?[1] ?? "sun.max.fill"
        } else {
            weatherInterpretationCodes[weatherCode]?[2] ?? "moon.stars.fill"
        }
    }
}
