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
    let today = Date.now.formatted(.dateTime.weekday(.abbreviated))
    
    var body: some View {
        HStack {
            if day == today {
                Text("Today")
                    .frame(width: 46, alignment: .leading)
            } else {
                Text(day)
                    .frame(width: 46, alignment: .leading)
            }
            Image(systemName: weatherSymbol)
                .frame(width: 30)
                .font(.system(size: 20))
                .symbolRenderingMode(.multicolor)
            Text("L:\(minTemperature)º")
                .frame(width: 60, alignment: .center)
            Spacer()
            Text("H:\(maxTemperature)º")
                .frame(width: 60, alignment: .trailing)
        }
        .frame(maxWidth: 335)
        .foregroundStyle(.white)
        .padding(8)
//        .background(.brown)
    }
}

#Preview {
    let color = Color(red: 0.365, green: 0.459, blue: 0.478, opacity: 0.9)
    DailyView(day: "Today", minTemperature: "17", maxTemperature: "28", weatherSymbol: "sun.max.fill")
        .background(color)
}
