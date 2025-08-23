//
//  CurrentTempView.swift
//  Weather
//
//  Created by Mark Darby on 14/08/2025.
//

import CoreLocation
import CoreLocationUI
import SwiftUI

struct CurrentTempView: View {
    let cityName: String
    let currentTemperature: Int
    let CurrentWeatherDescription: String
    let CurrentHighTemperature: String
    let CurrentLowTemperature: String
    
    var body: some View {
        VStack {
            Text("\(cityName)")
            Label("\(currentTemperature)", systemImage: "sun.max.fill")
                .font(.system(size: 80))
                .fontWeight(.light)
                .symbolRenderingMode(.multicolor)
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
    CurrentTempView(cityName: "Hinckley", currentTemperature: 23, CurrentWeatherDescription: "Sunny", CurrentHighTemperature: "28", CurrentLowTemperature: "18")
        .background(
            Image(.pexelsToddTrapani4883821535162)
                .resizable()
        )

    Spacer()
}


//HStack {
//    Image(systemName: "sun.max.fill")
//        .resizable()
//        .scaledToFit()
//        .frame(width: 90, height: 90)
//        .symbolRenderingMode(.multicolor)
//    Text(" \(currentTemperature)º")
//        .font(.system(size: 80))
//        .fontWeight(.light)
//}
