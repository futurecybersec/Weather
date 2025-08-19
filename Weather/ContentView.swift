//
//  ContentView.swift
//  Weather
//
//  Created by Mark Darby on 11/08/2025.
//
// Documentation: https://open-meteo.com/
// More info and examples: https://github.com/open-meteo/sdk/tree/main/swift

// https://developer.apple.com/documentation/corelocation/converting-between-coordinates-and-user-friendly-place-names


//TODO: Location and weather do not update after initial allow share location request. It seems to work fine after that.


import CoreLocation
import SwiftUI


struct ContentView: View {
    @State private var weather: WeatherData?
    @StateObject private var locationManager = LocationManager()
    @State private var latitude: Double = 40.4167
    @State private var longitude: Double = 3.7033
    @State private var counter = 0
    @State private var cityName = "Yet Unknown"
    
    var currentTemperature: String {
        String(Int(weather?.current.temperature_2m.rounded() ?? 99))
    }
    
    var highTemperature: String {
        String(Int(weather?.daily.temperature_2m_max.first?.rounded() ?? 99))
    }
    
    var lowTemperature: String {
        String(Int(weather?.daily.temperature_2m_min.first?.rounded() ?? 99))
    }
    
    var weatherDescription: String {
        let code = weather?.current.weather_code
        return weatherInterpretationCodes[code ?? 100] ?? ""
        
    }
    
    var onlyTime: String {
        let originalTime = weather?.current.time ?? "2025-08-17T11:15"
        let splitDateTime = processTime(time: originalTime)
        return String(splitDateTime[1])
    }
    
    var onlyDate: String {
        let originalTime = weather?.current.time ?? "2025-08-17T11:15"
        let splitDateTime = processTime(time: originalTime)
        return String(splitDateTime[0])
    }
    
    
    var body: some View {
        VStack {
            CurrentTempView(location: cityName, currentTemperature: currentTemperature, weatherDescription: weatherDescription, highTemperature: highTemperature, lowTemperature: lowTemperature)
            Text("Time: \(onlyTime)")
            Text("Date: \(onlyDate)")
            Text("Latitude: \(latitude)")
            Text("Longitude: \(longitude)")
            Text("Counter: \(counter)")
            
            Button("UPDATE LOCATION") {
                Task {
                    await getLocation()
                }
            }
            .padding()
            
            Button("GET WEATHER") {
                Task {
                    await updateWeather()
                }
            }
            
            Button("INCREASE COUNTER") {
                counter += 1
            }
            
            Button("GET CITY NAME") {
                Task {
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude) // Los Angeles, CA
                    
                    if let cityName = await getCityName(for: coordinate) {
                        print("City Name: \(cityName)")
                        self.cityName = cityName
                    } else {
                        print("Could not determine city name for the given coordinates.")
                    }
                }
            }
            .padding()
            Spacer()
            Button("Debug") {
                debugValues()
            }
            .foregroundStyle(.red)
        }
        .task {
            await processWeather()
            
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
    
    func processCityName() async {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if let cityName = await getCityName(for: coordinate) {
            print("City Name: \(cityName)")
            self.cityName = cityName
        } else {
            print("Could not determine city name for the given coordinates.")
        }
    }
    
    func processWeather() async {
        await getLocation()
        await updateWeather()
        await processCityName()
        
    }
    // Use location manager to get latitude and longitude
    func getLocation() async {
        locationManager.checkLocationAuthorization()
        
        if let coordinate = locationManager.lastKnownLocation {
            latitude = coordinate.latitude
            longitude = coordinate.longitude
        }
    }
    // Call the getWeather function and handle errors
    func updateWeather() async {
        do {
            weather = try await getWeather()
            debugValues()
            print("WEATHER UPDATED 2")
        } catch WeatherError.invalidURL {
            print("Invalid URL 2")
        } catch WeatherError.invalidResponse {
            print("Invalid response 2")
        } catch WeatherError.invalidData {
            print("Invalid data 2")
        } catch {
            print("Unexpected error 2")
        }
    }
    // Get weather from using API
    func getWeather() async throws -> WeatherData {
        // This gives the actual JSON. Paste into browser to view
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_max,temperature_2m_min&current=temperature_2m,weather_code&timezone=Europe%2FLondon"
        
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

    }
    
    func processTime(time: String) -> [Substring] {
        let dateAndTime = time.split(separator: "T")
        return dateAndTime
    }
    

    //https://medium.com/@wesleymatlock/unlocking-the-power-of-cllocation-working-with-geolocation-in-swift-0d07fe73a8b8
    func getCityName(for coordinate: CLLocationCoordinate2D) async -> String? {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        return await withCheckedContinuation { continuation in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard error == nil else {
                    print("Error in reverse geocoding: \(error!.localizedDescription)")
                    continuation.resume(returning: nil)
                    return
                }
                
                if let placemark = placemarks?.first, let city = placemark.locality {
                    continuation.resume(returning: city)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
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
        let weather_code: Int
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


let weatherInterpretationCodes: [Int: String] = [0: "Clear Sky",
                                                 1: "Mainly Clear",
                                                 2: "Partly Cloudy",
                                                 45: "Fog",
                                                 48: "Fog",
                                                 51: "Light Drizzle",
                                                 53: "Moderate Drizzle",
                                                 55: "Dense Drizzle",
                                                 56: "Light Freezing Drizzle",
                                                 57: "Intense Freezing Drizzle",
                                                 61: "Slight Rain",
                                                 63: "Moderate Rain",
                                                 65: "Heavy Rain",
                                                 66: "Light Freezing Rain",
                                                 67: "Heavy Freezig Rain",
                                                 71: "Slight Snow",
                                                 73: "Moderate Snow",
                                                 75: "Heavy Snow",
                                                 77: "Snow Grains",
                                                 80: "Slight Rain Showers",
                                                 81: "Moderate Rain Showers",
                                                 82: "Violent Rain Showers",
                                                 85: "Slight Snow Showers",
                                                 86: "Heavy Snow Showers",
                                                 95: "Slight Thunderstorm",
                                                 96: "Thunderstorm with Slight Hail",
                                                 99: "Thunderstorm with Heavy Hail",
                                                 100: ""]


//        print("latitude: \(weather?.latitude ?? 0)")
//        print("longitude: \(weather?.longitude ?? 0)")
//        print("generation_ms: \(weather?.generationtime_ms ?? 0)")
//        print("utc_offset_seconds: \(weather?.utc_offset_seconds ?? 0)")
//        print("timezone: \(weather?.timezone ?? "")")
//        print("timezone_abbreviation: \(weather?.timezone_abbreviation ?? "")")
//        print("elevation: \(weather?.elevation ?? 0)")
//        print("current time: \(weather?.current.time ?? "")")
//        print("current temperature: \(weather?.current.temperature_2m ?? 0)")
