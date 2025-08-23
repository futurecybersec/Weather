//
//  ContentView.swift
//  Weather
//
//  Created by Mark Darby on 11/08/2025.
//
// Documentation for weather API: https://open-meteo.com/

//TODO: Location and weather do not update after initial allow share location request. It seems to work fine after that.

import CoreLocation
import SwiftUI


struct HourlyMeasurement {
    let time: Date
    let temp: Double
}


struct ContentView: View {
    @State private var weather: WeatherData?
    @StateObject private var locationManager = LocationManager()
    @State private var latitude: Double = 40.4167
    @State private var longitude: Double = 3.7033
    @State private var cityName = "--"
    

    let forecastDays = 1
    
    var currentTemperature: Int {
        Int(weather?.current.temperature2M.rounded() ?? 99)
    }
    
    var CurrentHighTemperature: String {
        String(Int(weather?.daily.temperature2MMax.first?.rounded() ?? 99))
    }
    
    var CurrentLowTemperature: String {
        String(Int(weather?.daily.temperature2MMin.first?.rounded() ?? 99))
    }
    
    var CurrentWeatherDescription: String {
        let code = weather?.current.weatherCode
        return weatherInterpretationCodes[code ?? 100] ?? ""
    }
    
    var timeAndTemps: [HourlyMeasurement] {
        guard let times = weather?.hourly.time, let temps = weather?.hourly.temperature2M else {
            return []
        }
        return Array(zip(times, temps)).map { HourlyMeasurement(time: $0.0, temp: $0.1) }
    }
    
    var timeAndTempsFromNowOn: [HourlyMeasurement] {
        var hourlyMeasurement: [HourlyMeasurement] = []
        let now = Date.now
        for i in timeAndTemps {
            if i.time > now {
                hourlyMeasurement.append(i)
            }
        }
        return hourlyMeasurement
    }
    
    var body: some View {
        VStack {
            CurrentTempView(cityName: cityName, currentTemperature: currentTemperature, CurrentWeatherDescription: CurrentWeatherDescription, CurrentHighTemperature: CurrentHighTemperature, CurrentLowTemperature: CurrentLowTemperature)
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        HourlyView(hour: "Now", hourlyTemp: currentTemperature)
                        
                        ForEach(timeAndTempsFromNowOn, id: \.time) { hourly in
                            HourlyView(hour: hourly.time.formatted(date: .omitted, time: .shortened), hourlyTemp: Int(hourly.temp.rounded()))
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(maxWidth: .infinity)
                
            }
            .background(.brown)
            .clipShape(.rect(cornerRadius: 20))
            .padding()
            
            Spacer()
            
            VStack {
                Text("\(weather?.current.time.formatted() ?? "Error")")
                Text("Latitude: \(latitude)")
                Text("Longitude: \(longitude)")
            }
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .padding()
        }
        .task {
            await processWeather()
            
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.pexelsToddTrapani4883821535162)
                .resizable()
                .ignoresSafeArea()
        )
    }
    
    func processWeather() async {
        await getLocation()
        await updateWeather()
        await processCityName()
    }
    
    func processCityName() async {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if let cityName = await getCityName(for: coordinate) {
            self.cityName = cityName
        } else {
            print("Could not determine city name for the given coordinates.")
        }
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
    // Get weather from using API
    func getWeather() async throws -> WeatherData {
        // This gives the actual JSON. Paste into browser to view
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_max,temperature_2m_min&hourly=temperature_2m&current=temperature_2m,weather_code&timezone=GMT&forecast_days=\(forecastDays)"
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
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
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
    }
    
    struct Daily: Codable {
        let time: [Date]
        let temperature2MMax: [Double]
        let temperature2MMin: [Double]
        
        // Custom decoding for the different date format
        private enum CodingKeys: String, CodingKey {
            case time, temperature2MMax, temperature2MMin
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
        }
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
                                                 3: "Overcast",
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
