//
//  ContentView.swift
//  Weather
//
//  Created by Mark Darby on 11/08/2025.
//
// Documentation: https://open-meteo.com/
// More info and examples: https://github.com/open-meteo/sdk/tree/main/swift


import SwiftUI

struct ContentView: View {
    @State private var weather: WeatherData?
    
    var currentTemperature: String {
        String(Int(weather?.current.temperature_2m.rounded() ?? 99))
    }
    
    var highTemperature: String {
        String(Int(weather?.daily.temperature_2m_max.first?.rounded() ?? 99))
    }
    
    var lowTemperature: String {
        String(Int(weather?.daily.temperature_2m_min.first?.rounded() ?? 99))
    }
    
    var body: some View {
        VStack {
            CurrentTempView(location: "Hinckley and Bosworth", currentTemperature: currentTemperature, weatherDescription: "Clear Skies", highTemperature: highTemperature, lowTemperature: lowTemperature)
            Spacer()
            Button("Debug") {
                debugValues()
            }
            .foregroundStyle(.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
        .task {
            do {
                weather = try await getWeather()
                debugValues()
            } catch WeatherError.invalidURL {
                print("Invalid URL")
            } catch WeatherError.invalidResponse {
                print("Invalid response")
            } catch WeatherError.invalidData {
                print("Invalid data")
            } catch {
                print("Unexpected error")
            }
        }
    }
    func getWeather() async throws -> WeatherData {

        // This gives the actual JSON. Paste into browser to view
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=52.5561&longitude=-1.3709&daily=temperature_2m_max,temperature_2m_min&current=temperature_2m&timezone=Europe%2FLondon"
        
        
        // Convert endpoint to URL
        guard let url = URL(string: endpoint) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        // Convert JSON into WeatherData object
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            throw WeatherError.invalidData
        }
        
    }
    func debugValues() {
        print("debugDescription: \(weather.debugDescription)")
        print("latitude: \(weather?.latitude ?? 0)")
        print("longitude: \(weather?.longitude ?? 0)")
        print("generation_ms: \(weather?.generationtime_ms ?? 0)")
        print("utc_offset_seconds: \(weather?.utc_offset_seconds ?? 0)")
        print("timezone: \(weather?.timezone ?? "")")
        print("timezone_abbreviation: \(weather?.timezone_abbreviation ?? "")")
        print("elevation: \(weather?.elevation ?? 0)")
        print("current time: \(weather?.current.time ?? "")")
        print("current temperature: \(weather?.current.temperature_2m ?? 0)")
    }
}

#Preview {
    ContentView()
}

struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let generationtime_ms: Double
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let elevation: Int
    let current_units: CurrentUnits
    let current: Current
    let daily: Daily

    struct CurrentUnits: Codable {
        let time: String
        let temperature_2m: String
    }

    struct Current: Codable {
        let time: String
        let temperature_2m: Double
    }
    
    struct Daily: Codable {
        let time: [String]
        let temperature_2m_max: [Double]
        let temperature_2m_min: [Double]
    }
}

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}


