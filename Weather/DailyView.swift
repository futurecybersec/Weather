//
//  DayView.swift
//  Weather
//
//  Created by Mark Darby on 14/08/2025.
//

import SwiftUI

struct DailyView: View {
    
    let minTemperature: Double
    let maxTemperature: Double
    
    var RoundedMinTemperature: String {
        String(Int(minTemperature.rounded()))+"º"
    }
    
    var RoundedMaxTemperature: String {
        String(Int(maxTemperature.rounded()))+"º"
    }
    
    
    var body: some View {
        HStack {
            Text("Today")
            Image(systemName: "sun.max.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.multicolor)
            Text(RoundedMinTemperature)
            Text(RoundedMaxTemperature)
        }
        .bold()
        .foregroundStyle(.white)
        .padding()
        .background(.blue)
    }
}

#Preview {
    DailyView(minTemperature: 17.2, maxTemperature: 28.9)
}
