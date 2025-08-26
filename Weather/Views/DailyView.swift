//
//  DayView.swift
//  Weather
//
//  Created by Mark Darby on 14/08/2025.
//

import SwiftUI

struct DailyView: View {
    let day: String
    let minTemperature: String
    let maxTemperature: String
    let weatherSymbol: String
    
    
//    var roundedMinTemperature: String {
//        String(Int(minTemperature.rounded()))+"º"
//    }
//    
//    var roundedMaxTemperature: String {
//        String(Int(maxTemperature.rounded()))+"º"
//    }
    
    
    var body: some View {
        HStack {
            Text(day)
            Image(systemName: weatherSymbol)
                .font(.system(size: 20))
                .symbolRenderingMode(.multicolor)
            Text("L:\(minTemperature)º")
            Spacer()
            Text("H:\(maxTemperature)º")
        }
        .frame(maxWidth: 335)
        .foregroundStyle(.white)
        .padding(8)
        .background(.brown)
    }
}

#Preview {
    DailyView(day: "Today", minTemperature: "17", maxTemperature: "28", weatherSymbol: "sun.max.fill")
}
