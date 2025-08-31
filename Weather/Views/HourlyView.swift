//
//  HourlyView.swift
//  Weather
//
//  Created by Mark Darby on 25/08/2025.
//

import SwiftUI

struct HourlyView: View {
    let weatherSymbol: String
    let hour: String
    let hourlyTemperature: String


    let symbolVerticalPaddingDictionary: [String: Int] = ["sun.max.fill": 4,
                                        "cloud.sun.fill": 3,
                                        "cloud.fill": 8,
                                        "cloud.fog.fill": 3,
                                        "cloud.drizzle.fill": 3,
                                        "cloud.rain.fill": 3,
                                        "cloud.heavyrain.fill": 3,
                                        "cloud.snow.fill": 3,
                                        "cloud.bolt.fill": 3]
    
    
    var symbolVerticalPadding: CGFloat {
        CGFloat(symbolVerticalPaddingDictionary[weatherSymbol] ?? 3)
    }
    
    var body: some View {
        VStack {
            Text(hour)
            Spacer()
            Image(systemName: weatherSymbol)
                .font(.system(size: 25))
                .symbolRenderingMode(.multicolor)
                .padding(.vertical, symbolVerticalPadding)
            Spacer()
            Text(hourlyTemperature)
        }
        .frame(maxHeight: 100)
        .padding(.vertical, 6)
        .padding(.horizontal, 5)
    }
}


#Preview {
    let color = Color(red: 0.365, green: 0.459, blue: 0.478, opacity: 0.9)
    HourlyView(weatherSymbol: "sun.max.fill", hour: "8:00", hourlyTemperature: "25")
        .frame(width: 70, height: 120)
        .background(color)
        .foregroundStyle(.white)
}
