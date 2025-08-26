//
//  ContentView.swift
//  Weather
//
//  Created by Mark Darby on 11/08/2025.
//
// Documentation for weather API: https://open-meteo.com/

//TODO: Location and weather do not update after initial allow share location request. It seems to work fine after that.

//TODO: Have a different background picture depending on weather

//TODO: Change weather symbols for night time

//TODO: Add DailyView to ContentView

//TODO: Symbols in HourlyView still don't line up perfectly

//TODO: Experiment with symbol animations

import CoreLocation
import SwiftUI



struct MainView: View {
    @State private var weather: WeatherData?
    @StateObject private var locationManager = LocationManager()
    @State private var latitude: Double = 40.4167
    @State private var longitude: Double = 3.7033
    @State private var cityName = "--"
    @State private var isNight = false
    
    

    let forecastDays = 10
    
    var currentTemperature: String {
        String(Int(weather?.current.temperature2M.rounded() ?? 99))
    }
    
    var currentHighTemperature: String {
        String(Int(weather?.daily.temperature2MMax.first?.rounded() ?? 99))
    }
    
    var currentLowTemperature: String {
        String(Int(weather?.daily.temperature2MMin.first?.rounded() ?? 99))
    }
    
    var currentWeatherDescription: String {
        let code = weather?.current.weatherCode ?? 0
        return weatherInterpretationCodes[code]?.first ?? ""
    }
    
    var currentWeatherSymbolSmall: String {
        let code = weather?.current.weatherCode ?? 0
        return weatherInterpretationCodes[code]?[1] ?? "sun.max.fill"
    }
    
    struct HourlyMeasurement {
        let time: Date
        let temp: Double
        let weatherCode: Int
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
    
    struct DailyMeasurement {
        let time: Date
        let minTemperature: Double
        let maxTemperature: Double
        let weatherCode: Int
    }
    
    var dailyMeasurements: [DailyMeasurement] {
        var daily: [DailyMeasurement] = []
        guard let times = weather?.daily.time, let minTemperatures = weather?.daily.temperature2MMin, let maxTemperatures = weather?.daily.temperature2MMax, let weatherCodes = weather?.daily.weatherCode else { return [] }
        for (i, time) in times.enumerated() {
            let minTemperature = minTemperatures[i]
            let maxTemperature = maxTemperatures[i]
            let weatherCode = weatherCodes[i]
            let dailyMeasurement = DailyMeasurement(time: time, minTemperature: minTemperature, maxTemperature: maxTemperature, weatherCode: weatherCode)
            daily.append(dailyMeasurement)
        }
        return daily
    }
    
    var body: some View {
        VStack {
            CurrentTemperatureView(cityName: cityName, currentTemperature: currentTemperature, currentWeatherDescription: currentWeatherDescription, currentHighTemperature: currentHighTemperature, currentLowTemperature: currentLowTemperature)
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        HourlyView(image: currentWeatherSymbolSmall, hour: "Now", hourlyTemperature: currentTemperature)
                        
                        ForEach(timeAndTempsFromNowOn, id: \.time) { hourly in
                            //TODO: Move this logic to timeAndTempsFromNowOn or timeAndTemps
                            let image = weatherInterpretationCodes[hourly.weatherCode]?[1] ?? "sun.max.fill"
                            let hour = hourly.time.formatted(date: .omitted, time: .shortened)
                            let hourlyTemperature = String(Int(hourly.temp.rounded()))
                            
                            HourlyView(image: image, hour: hour, hourlyTemperature: hourlyTemperature)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(maxWidth: .infinity)
            }
            .background(.brown)
            .clipShape(.rect(cornerRadius: 20))
            .padding()
            
            VStack(spacing: 0) {
                ForEach(dailyMeasurements, id: \.time) { dailyMeasurement in
                    //TODO: Move this logic to var dailyMeasurements
                    let minTemperature = String(Int(dailyMeasurement.minTemperature.rounded()))
                    let maxTemperature = String(Int(dailyMeasurement.maxTemperature.rounded()))
                    let weatherSymbol = weatherInterpretationCodes[dailyMeasurement.weatherCode]?[1] ?? "sun.fill.max"
                    let day = dailyMeasurement.time.formatted(.dateTime.weekday(.abbreviated))
                    
                    DailyView(day: day, minTemperature: minTemperature, maxTemperature: maxTemperature, weatherSymbol: weatherSymbol)
                }
            }
            .clipShape(.rect(cornerRadius: 20))

            
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
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_min,temperature_2m_max,weather_code&hourly=temperature_2m,weather_code&current=temperature_2m,weather_code&timezone=GMT&forecast_days=\(forecastDays)"
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
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Failed to decode due to missing key '\(key.stringValue)' – \(context.debugDescription)")
            throw WeatherError.invalidData
        } catch DecodingError.typeMismatch(_, let context) {
            print("Failed to decode due to type mismatch – \(context.debugDescription)")
            throw WeatherError.invalidData
        } catch DecodingError.valueNotFound(let type, let context) {
            print("Failed to decode to missing \(type) value – \(context.debugDescription)")
            throw WeatherError.invalidData
        } catch DecodingError.dataCorrupted(_) {
            print("Failed to decode because it appears to be invalid JSON.")
            throw WeatherError.invalidData
        } catch {
            print("Failed to decode: \(error.localizedDescription)")
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
    MainView()
}

//let dummyData = [HourlyMeasurement(time: Date.now, temp: 25.5, weatherCode: 0),
//                 HourlyMeasurement(time: Date.now + 1, temp: 25.5, weatherCode: 2),
//                 HourlyMeasurement(time: Date.now + 2, temp: 25.5, weatherCode: 3),
//                 HourlyMeasurement(time: Date.now + 3, temp: 25.5, weatherCode: 45),
//                 HourlyMeasurement(time: Date.now + 4, temp: 25.5, weatherCode: 51),
//                 HourlyMeasurement(time: Date.now + 5, temp: 25.5, weatherCode: 61),
//                 HourlyMeasurement(time: Date.now + 6, temp: 25.5, weatherCode: 65),
//                 HourlyMeasurement(time: Date.now + 7, temp: 25.5, weatherCode: 71),
//                 HourlyMeasurement(time: Date.now + 8, temp: 25.5, weatherCode: 95)]


// Below code is for playing around with spacing so text aligns
//            VStack {
//                ScrollView(.horizontal) {
//                    HStack(spacing: 0) {
//                        ForEach(dummyData, id: \.time) { hourly in
//
//                            let image = weatherInterpretationCodes2[hourly.weatherCode]?[1] ?? "sun.max.fill"
//                            let hour = hourly.time.formatted(date: .omitted, time: .shortened)
//                            let hourlyTemperature = String(Int(hourly.temp.rounded()))
//
//                            HourlyView(image: image, hour: hour, hourlyTemperature: hourlyTemperature)
//                        }
//                    }
//                }
//                .scrollIndicators(.hidden)
//                .frame(maxWidth: .infinity)
//            }
//            .background(.brown)
