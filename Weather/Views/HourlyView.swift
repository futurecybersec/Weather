//
//  HourlyView.swift
//  Weather
//
//  Created by Mark Darby on 25/08/2025.
//

import SwiftUI

struct HourlyView: View {
    let image: String
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
        CGFloat(symbolVerticalPaddingDictionary[image] ?? 3)
    }
    
    var body: some View {
        VStack {
            Text("\(hour)")
                .bold()
            Spacer()
            Image(systemName: image)
                .font(.system(size: 30))
                .symbolRenderingMode(.multicolor)
                .padding(.vertical, symbolVerticalPadding)
            Spacer()
            Text("\(hourlyTemperature)º")
                .bold()
        }
        .frame(maxHeight: 90)
        .padding()
    }
}


#Preview {
    HourlyView(image: "sun.max.fill", hour: "8:00", hourlyTemperature: "25")
        .frame(width: 70, height: 120)
        .background(.brown)
        .foregroundStyle(.white)
}
