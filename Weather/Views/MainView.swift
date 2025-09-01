//
//  ContentView.swift
//  Weather
//
//  Created by Mark Darby on 11/08/2025.
//
// Documentation for weather API: https://open-meteo.com/

//TODO: Location and weather do not update after initial allow share location request. It seems to work fine after that.

//TODO: Experiment with symbol animations

//TODO: Change code so it only updates performs reverse geo if the user's location has changed significantly

//TODO: refresh weather every 15 minutes?

//TODO: Fade views when scrolling up and shrink current view

import CoreLocation
import SwiftUI

struct DividerView: View {
    let isDay: Bool
    
    var body: some View {
        Divider()
            .overlay(isDay ? .gray : .pink)
            .opacity(isDay ? 1 : 0.6)
    }
}

struct MainView: View {
    @State private var weather: WeatherData?
    @StateObject private var locationManager = LocationManager()
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var locationTimeZone = TimeZone.current.identifier
    @State private var cityName = "--"
    @State private var isCurrentlyDay = true
    
    
    let backgroundImages: [ImageResource] = [ImageResource.pexelsEberhardgross1366919, ImageResource.pexelsBrakou1723637]
    
    let colors = [Color(red: 0.365, green: 0.459, blue: 0.478, opacity: 0.9), Color(red: 0.427, green: 0.259, blue: 0.243, opacity: 0.4)]
    
    var sunrises: [Date] {
        weather?.daily.sunrise ?? []
    }
    
    var sunsets: [Date] {
        weather?.daily.sunset ?? []
    }
    
    let forecastDays = 10
    
    var endpoint: String {
        "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_min,temperature_2m_max,weather_code,sunrise,sunset&hourly=temperature_2m,weather_code,is_day&current=temperature_2m,weather_code,is_day&timezone=\(locationTimeZone)&forecast_days=\(forecastDays)"
    }
        
    
    let color = Color(red: 0.365, green: 0.459, blue: 0.478, opacity: 0.9)

    
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
    

    var timeAndTemperatures: [HourlyMeasurement] {
        var hourlyMeasurements: [HourlyMeasurement] = []
        
        guard let times = weather?.hourly.time, let temps = weather?.hourly.temperature2M, let codes = weather?.hourly.weatherCode, let isDayArray = weather?.hourly.isDay else { return [] }
        for (i, time) in times.enumerated() {
            let temp = temps[i]
            let code = codes[i]
            let isDay = isDayArray[i]
            let hourlyMeasurement = HourlyMeasurement(time: time, temperature: temp, weatherCode: code, isDay: isDay == 1 ? true : false)
            hourlyMeasurements.append(hourlyMeasurement)
        }
        return hourlyMeasurements
    }
    
    var timeAndTemperaturesFromNowOn: [HourlyMeasurement] {
        var hourlyMeasurements: [HourlyMeasurement] = []
        let now = Date.now
        for i in timeAndTemperatures {
            if i.time > now {
                hourlyMeasurements.append(i)
            }
        }
        return hourlyMeasurements
    }
    
    var dailyMeasurements: [DailyMeasurement] {
        var daily: [DailyMeasurement] = []
        guard let times = weather?.daily.time,
              let minTemperatures = weather?.daily.temperature2MMin,
              let maxTemperatures = weather?.daily.temperature2MMax,
              let weatherCodes = weather?.daily.weatherCode,
              let sunrises = weather?.daily.sunrise,
              let sunsets = weather?.daily.sunset else { return [] }
        for (i, time) in times.enumerated() {
            let minTemperature = minTemperatures[i]
            let maxTemperature = maxTemperatures[i]
            let weatherCode = weatherCodes[i]
            let sunrise = sunrises[i]
            let sunset = sunsets[i]
            let dailyMeasurement = DailyMeasurement(time: time, minTemperature: minTemperature, maxTemperature: maxTemperature, weatherCode: weatherCode, sunrise: sunrise, sunset: sunset)
            daily.append(dailyMeasurement)
        }
        return daily
    }
    
    var body: some View {
        VStack {
            CurrentTemperatureView(cityName: cityName, currentTemperature: currentTemperature, currentWeatherDescription: currentWeatherDescription, currentHighTemperature: currentHighTemperature, currentLowTemperature: currentLowTemperature)
            Button("Toggle Day/Night") {
                isCurrentlyDay.toggle()
            }
            ScrollView {
                VStack(alignment: .leading) {
                    Label("HOURLY FORECAST", systemImage: "clock")
                        .font(.footnote)
                        .padding([.leading, .top], 6)
                    DividerView(isDay: isCurrentlyDay)
                    ScrollView(.horizontal) {
                        VStack {
                            HStack(spacing: 0) {
                                
                                Spacer(minLength: 4)
                                
                                HourlyView(weatherSymbol: currentWeatherSymbolSmall, hour: "Now", hourlyTemperature: currentTemperature)
                                
                                ForEach(timeAndTemperaturesFromNowOn.prefix(24), id: \.time) { hourlyMeasurement in
                                    
                                    if sunriseSunsetCheck(hourlyMeasurement: hourlyMeasurement, sunriseOrSunset: sunrises[0]) {
                                        HourlyView(weatherSymbol: "sunrise.fill", hour: dateFormatter(date: sunrises[0]), hourlyTemperature: "Sunrise")
                                    }
                                    
                                    if sunriseSunsetCheck(hourlyMeasurement: hourlyMeasurement, sunriseOrSunset: sunrises[1]) {
                                        HourlyView(weatherSymbol: "sunrise.fill", hour: dateFormatter(date: sunrises[1]), hourlyTemperature: "Sunrise")
                                    }
                                    
                                    if sunriseSunsetCheck(hourlyMeasurement: hourlyMeasurement, sunriseOrSunset: sunsets[0]) {
                                        HourlyView(weatherSymbol: "sunset.fill", hour: dateFormatter(date: sunsets[0]), hourlyTemperature: "Sunset")
                                    }
                                    
                                    if sunriseSunsetCheck(hourlyMeasurement: hourlyMeasurement, sunriseOrSunset: sunsets[1]) {
                                        HourlyView(weatherSymbol: "sunset.fill", hour: dateFormatter(date: sunsets[1]), hourlyTemperature: "Sunset")
                                    }

                                    HourlyView(weatherSymbol: hourlyMeasurement.weatherSymbol, hour: hourlyMeasurement.formattedTime, hourlyTemperature: hourlyMeasurement.formattedTemperature)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: 350)
                .background(isCurrentlyDay ? colors[0] : colors[1])
                .clipShape(.rect(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 0) {
                    Label("10-DAY FORECAST", systemImage: "calendar")
                        .font(.footnote)
                        .padding(6)
                    DividerView(isDay: isCurrentlyDay)
                    ForEach(dailyMeasurements, id: \.time) { dailyMeasurement in
                        DailyView(day: dailyMeasurement.day, minTemperature: dailyMeasurement.formattedMinTemperature, maxTemperature: dailyMeasurement.formattedMaxTemperature, weatherSymbol: dailyMeasurement.weatherSymbol)
                        DividerView(isDay: isCurrentlyDay)
                            .padding(.horizontal)
                    }
                }
                .frame(maxWidth: 350)
                .background(isCurrentlyDay ? colors[0] : colors[1])
                .clipShape(.rect(cornerRadius: 10))
                
                Spacer()
                
                VStack {
                    Text("\(weather?.current.time.formatted() ?? "Error")")
                    Text("Date.now(): \(Date.now.formatted())")
                    Text("Latitude: \(latitude)")
                    Text("Longitude: \(longitude)")
                    Text("Location Time Zone \(locationTimeZone)")
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .task {
                await processWeather()
                
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Image(isCurrentlyDay ? backgroundImages[0] : backgroundImages[1])
                .resizable()
                .ignoresSafeArea()
        )
    }
    // Format date in 24 hour format with hour and minutes
    func dateFormatter(date: Date) -> String {
        return date.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
    }
    // Check if sunrise or sunset should be inserted
    func sunriseSunsetCheck(hourlyMeasurement: HourlyMeasurement, sunriseOrSunset: Date) -> Bool {
        let currentTime = hourlyMeasurement.time
        if currentTime.timeIntervalSince(sunriseOrSunset) > 0 && currentTime.timeIntervalSince(sunriseOrSunset) < 3600 {
            return true
        } else {
            return false
        }
    }
    
    func processWeather() async {
        await getCoordinates()
        await getLocationDetails()
        await updateWeather()
        if weather?.current.isDay == 1 {
            isCurrentlyDay = true
        } else {
            isCurrentlyDay = false
        }
    }
    
    // Use location manager to get latitude and longitude
    func getCoordinates() async {
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
        print(endpoint)
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
    // Obtain city name and timezone from coordinates
    func getLocationDetails() async {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            if let placemark = placemarks.first, let city = placemark.locality, let timeZone = placemark.timeZone {
                self.cityName = city
                self.locationTimeZone = timeZone.identifier
            } else {
                print("Could not determine location details for the given coordinates.")
                return
            }
        } catch {
            print("Reverse geocoding failed: \(error)")
            return
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
