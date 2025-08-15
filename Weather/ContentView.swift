//
//  ContentView.swift
//  Weather
//
//  Created by Mark Darby on 11/08/2025.
//
// Documentation: https://open-meteo.com/
// More info and examples: https://github.com/open-meteo/sdk/tree/main/swift


import OpenMeteoSdk
import SwiftUI

struct ContentView: View {
    @State private var currentTemperature: String?
    @State private var weatherData: WeatherData?
    
    
    var body: some View {
        VStack {
            Image(systemName: "sun.max.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .symbolRenderingMode(.multicolor)
            
                .foregroundStyle(.tint)
            if currentTemperature != nil {
                Text("\(currentTemperature ?? "100")º")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
        .task {
            do {
                try await getWeather()
            } catch {
                print("Unexpected error")
            }
        }
    }
    func getWeather() async throws {
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=52.5561&longitude=-1.3709&hourly=temperature_2m&current=temperature_2m&timezone=Europe%2FLondon&forecast_days=1&format=flatbuffers"
        
        // Convert endpoint to URL
        guard let url = URL(string: endpoint) else { throw WeatherError.invalidURL }
        
        // Get response using API
        let responses = try await WeatherApiResponse.fetch(url: url)
        
        // If single location, the one we want is the first in the array
        let response = responses[0]
        
        // Universal Coordinated Time offset for our location
        let utcOffsetSeconds = response.utcOffsetSeconds
        
        guard let hourly = response.hourly else { throw WeatherError.invalidResponse }

        // Times for each hourly sample
        let times = hourly.getDateTime(offset: utcOffsetSeconds)

        guard let temps = hourly.variables(at: 0)?.values as? [Float] else {
            throw WeatherError.invalidData
        }

        if let current = response.current, let tNow = current.variables(at: 0)?.value as? Float {
            currentTemperature = tNow.formatted(.number.rounded(increment: 1.0))
        }
        
        let data = WeatherData(
            hourly: .init(
                time: times,
                temperature2m: temps
            )
        )
        
        // Timezone '.gmt' is deliberately used.
        // By adding 'utcOffsetSeconds' before, local-time is inferred
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        for (i, date) in data.hourly.time.enumerated() {
            print(dateFormatter.string(from: date))
            print(data.hourly.temperature2m[i])
        }
    }
}

#Preview {
    ContentView()
}

struct WeatherData {
    let hourly: Hourly

    struct Hourly {
        let time: [Date]
        let temperature2m: [Float]
    }
}

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}


