//
//  ContentView.swift
//  Weather
//
//  Created by Mark Darby on 11/08/2025.
//
// Documentation for weather API: https://open-meteo.com/

//TODO: Location and weather do not update after initial allow share location request. It seems to work fine after that.

//TODO: Have a different background picture depending on weather

import CoreLocation
import SwiftUI


struct HourlyMeasurement {
    let time: Date
    let temp: Double
    let weatherCode: Int
}



struct ContentView: View {
    @State private var weather: WeatherData?
    @StateObject private var locationManager = LocationManager()
    @State private var latitude: Double = 40.4167
    @State private var longitude: Double = 3.7033
    @State private var cityName = "--"
    

    let forecastDays = 3
    
    var currentTemperature: Int {
        Int(weather?.current.temperature2M.rounded() ?? 99)
    }
    
    var currentHighTemperature: String {
        String(Int(weather?.daily.temperature2MMax.first?.rounded() ?? 99))
    }
    
    var currentLowTemperature: String {
        String(Int(weather?.daily.temperature2MMin.first?.rounded() ?? 99))
    }
    
    var currentWeatherDescription: String {
        let code = weather?.current.weatherCode ?? 0
        return weatherInterpretationCodes[code]?.first as? String ?? ""
    }
    
    var currentWeatherSymbol: AnyView {
        let code = weather?.current.weatherCode ?? 0
        if let symbol = weatherInterpretationCodes[code]?[1] as? AnyView {
            return symbol
        } else {
            return AnyView(sunny) // fallback, wrapped in AnyView
        }
    }
    
    var currentWeatherSymbolSmall: AnyView {
        let code = weather?.current.weatherCode ?? 0
        if let symbol = weatherInterpretationCodes[code]?[2] as? AnyView {
            return symbol
        } else {
            return AnyView(sunny) // fallback, wrapped in AnyView
        }
    }
    
    
    var timeAndTemps: [HourlyMeasurement] {
        var hourlyMeasurements: [HourlyMeasurement] = []
        
        guard let times = weather?.hourly.time, let temps = weather?.hourly.temperature2M, let codes = weather?.hourly.weatherCode else { return [] }
        for (i, time) in times.enumerated() {
            let temp = temps[i]
            let code = codes[i]
            let hourlyMeasurement = HourlyMeasurement(time: time, temp: temp, weatherCode: code)
            hourlyMeasurements.append(hourlyMeasurement)
        }
        return hourlyMeasurements
    }
    
    var timeAndTempsFromNowOn: [HourlyMeasurement] {
        var hourlyMeasurements: [HourlyMeasurement] = []
        let now = Date.now
        for i in timeAndTemps {
            if i.time > now {
                hourlyMeasurements.append(i)
            }
        }
        return hourlyMeasurements
    }
    
    var body: some View {
        VStack {
            CurrentTempView(symbol: currentWeatherSymbol, cityName: cityName, currentTemperature: currentTemperature, CurrentWeatherDescription: currentWeatherDescription, CurrentHighTemperature: currentHighTemperature, CurrentLowTemperature: currentLowTemperature)
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        HourlyView(hourlySymbol: currentWeatherSymbolSmall, hour: "Now", hourlyTemp: currentTemperature)
                        //TODO: Tidy up below code
                        //TODO: Time and Temp text do not line up when weather symbols are different
                        ForEach(timeAndTempsFromNowOn, id: \.time) { hourly in
                            HourlyView(hourlySymbol: weatherInterpretationCodes[hourly.weatherCode]?[2] as? AnyView, hour: hourly.time.formatted(date: .omitted, time: .shortened), hourlyTemp: Int(hourly.temp.rounded()))
                        }
                    }
                }// weatherInterpretationCodes[hourly.weatherCode]?[2]
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
    }//https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=temperature_2m_min,temperature_2m_max&hourly=temperature_2m,weather_code&current=temperature_2m,weather_code&timezone=GMT&forecast_days=3
    // Get weather from using API
    func getWeather() async throws -> WeatherData {
        // This gives the actual JSON. Paste into browser to view
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_max,temperature_2m_min&hourly=temperature_2m,weather_code&current=temperature_2m,weather_code&timezone=GMT&forecast_days=\(forecastDays)"
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

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

#Preview {
    ContentView()
}







//        guard let times = weather?.hourly.time, let temps = weather?.hourly.temperature2M else {
//            return []
//        }
//        return Array(zip(times, temps)).map { HourlyMeasurement(time: $0.0, temp: $0.1) }
