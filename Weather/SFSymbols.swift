//
//  SFSymbols.swift
//  Weather
//
//  Created by Mark Darby on 17/08/2025.
//

import SwiftUI

struct SFSymbols: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Mainly Clear
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .symbolRenderingMode(.multicolor)
                // Partly Cloudy
                Image(systemName: "cloud.sun.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .yellow)
                // Fog
                Image(systemName: "cloud.fog.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .white)
                // Light Drizzle, Moderate Drizzle, Dense Drizzle, Light Freezing Drizzle,Intense Freezing Drizzle,
                Image(systemName: "cloud.drizzle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white, .blue)
                // Slight Rain, Moderate Rain. Light Freezing Rain
                Image(systemName: "cloud.rain.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white, .blue)
                // Heavy Rain, Heavy Freezing Rain
                Image(systemName: "cloud.heavyrain.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white, .blue)
                // Slight Snow, Moderate Snow, Heavy Snow, Snow Grains
                Image(systemName: "snowflake")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
            }
            .padding(50)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.indigo)
        }
    }
}

#Preview {
    SFSymbols()
}

// let weatherInterpretationCodes: [Int: String] = [0: "Clear Sky",
//1: "Mainly Clear",
//2: "Partly Cloudy",
//45: "Fog",
//48: "Fog",
//51: "Light Drizzle",
//53: "Moderate Drizzle",
//55: "Dense Drizzle",
//56: "Light Freezing Drizzle",
//57: "Intense Freezing Drizzle",
//61: "Slight Rain",
//63: "Moderate Rain",
//65: "Heavy Rain",
//66: "Light Freezing Rain",
//67: "Heavy Freezig Rain",
//71: "Slight Snow",
//73: "Moderate Snow",
//75: "Heavy Snow",
//77: "Snow Grains",
//80: "Slight Rain Showers",
//81: "Moderate Rain Showers",
//82: "Violent Rain Showers",
//85: "Slight Snow Showers",
//86: "Heavy Snow Showers",
//95: "Slight Thunderstorm",
//96: "Thunderstorm with Slight Hail",
//99: "Thunderstorm with Heavy Hail",
//100: ""]

