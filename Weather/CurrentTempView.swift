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
    
    let location: String
    let currentTemperature: String
    let weatherDescription: String
    let highTemperature: String
    let lowTemperature: String
    
    var body: some View {
        VStack {
            Text("\(location)")
            HStack {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .symbolRenderingMode(.multicolor)
                Text(" \(currentTemperature)º")
                    .font(.system(size: 80))
                    .fontWeight(.light)
            }
            Text("\(weatherDescription)")
            Text("Max: \(highTemperature)º Min: \(lowTemperature)º")
        }
        .padding(60)
        .bold()
        .foregroundStyle(.white)
    }
}

#Preview {
    CurrentTempView(location: "Hinckley and Bosworth", currentTemperature: "23", weatherDescription: "Sunny", highTemperature: "28", lowTemperature: "18")
        .background(.blue)
}


