//
//  CurrentTempView.swift
//  Weather
//
//  Created by Mark Darby on 14/08/2025.
//

import CoreLocation
import CoreLocationUI
import SwiftUI

struct CurrentTempView<Symbol: View>: View {
    let symbol: Symbol
    let cityName: String
    let currentTemperature: Int
    let CurrentWeatherDescription: String
    let CurrentHighTemperature: String
    let CurrentLowTemperature: String
    
    var body: some View {
        VStack {
            Text("\(cityName)")
                .font(.title3)
            HStack {
                Text("\(currentTemperature)º")
                symbol
            }
            .font(.system(size: 80))
            .fontWeight(.light)
            Text("\(CurrentWeatherDescription)")
            Text("Max: \(CurrentHighTemperature)º Min: \(CurrentLowTemperature)º")
        }
        .padding(50)
        .bold()
        .shadow(radius: 5)
        .foregroundStyle(.white)
    }
}

#Preview {
    CurrentTempView(
        symbol: Image(systemName: "sun.max.fill").symbolRenderingMode(.multicolor),
        cityName: "Hinckley",
        currentTemperature: 23,
        CurrentWeatherDescription: "Sunny",
        CurrentHighTemperature: "28",
        CurrentLowTemperature: "18"
    )
    .background(
        Image(.pexelsToddTrapani4883821535162)
            .resizable()
    )
}
