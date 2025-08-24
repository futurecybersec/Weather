//
//  HourlyView.swift
//  Weather
//
//  Created by Mark Darby on 21/08/2025.
//

import SwiftUI

struct HourlyView<Symbol: View>: View {
    let hourlySymbol: Symbol
    let hour: String
    let hourlyTemp: Int
    
    var body: some View {
        VStack {
            Text("\(hour)")
            hourlySymbol
            Text("\(hourlyTemp)º")
        }
        .frame(maxHeight: 90)
        .padding()
        .foregroundStyle(.white)
        .background(.brown)
    }
}

#Preview {
    HourlyView(hourlySymbol: sunnySmall, hour: "19", hourlyTemp: 18)
}
