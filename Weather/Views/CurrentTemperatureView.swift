//
//  CurrentTemperatureView.swift
//  Weather
//
//  Created by Mark Darby on 25/08/2025.
//

import SwiftUI

struct CurrentTemperatureView: View {
    let cityName: String
    let currentTemperature: String
    let currentWeatherDescription: String
    let currentHighTemperature: String
    let currentLowTemperature: String
    
    var body: some View {
        VStack {
            Text(cityName)
                .font(.title3)
            HStack {
                Text("\(currentTemperature)º")
            }
            .font(.system(size: 80))
            .fontWeight(.light)
            Text(currentWeatherDescription)
            Text("Max: \(currentHighTemperature)º Min: \(currentLowTemperature)º")
        }
        .padding(50)
        .bold()
        .shadow(radius: 5)
        .foregroundStyle(.white)
    }
}

#Preview {
    CurrentTemperatureView(cityName: "Hinckley", currentTemperature: "25", currentWeatherDescription: "Sunny", currentHighTemperature: "28", currentLowTemperature: "20")
        .frame(width: .infinity, height: .infinity)
        .background(.brown)
    Spacer()
}
