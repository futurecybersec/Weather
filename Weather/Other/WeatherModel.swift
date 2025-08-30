//
//  WeatherModel.swift
//  Weather
//
//  Created by Mark Darby on 23/08/2025.
//

import Foundation

struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let generationtimeMs: Double
    let utcOffsetSeconds: Int
    let timezone: String
    let timezoneAbbreviation: String
    let elevation: Int
    let current: Current
    let hourly: Hourly
    let daily: Daily

    struct Current: Codable {
        let time: Date
        let interval: Int
        let temperature2M: Double
        let weatherCode: Int
    }
    
    struct Hourly: Codable {
        let time: [Date]
        let temperature2M: [Double]
        let weatherCode: [Int]
        let isDay: [Int]
    }
    
    struct Daily: Codable {
        let time: [Date]
        let temperature2MMax: [Double]
        let temperature2MMin: [Double]
        let weatherCode: [Int]
        
        // Custom decoding for the different date format
        private enum CodingKeys: String, CodingKey {
            case time, temperature2MMax, temperature2MMin, weatherCode
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let timeStrings = try container.decode([String].self, forKey: .time)
            let formatterDaily = DateFormatter()
            formatterDaily.dateFormat = "yyyy-MM-dd"
            formatterDaily.timeZone = TimeZone(secondsFromGMT: 0)
            self.time = timeStrings.compactMap { formatterDaily.date(from: $0) }

            self.temperature2MMax = try container.decode([Double].self, forKey: .temperature2MMax)
            self.temperature2MMin = try container.decode([Double].self, forKey: .temperature2MMin)
            self.weatherCode = try container.decode([Int].self, forKey: .weatherCode)
        }
    }
}
