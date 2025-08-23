//
//  HourlyView.swift
//  Weather
//
//  Created by Mark Darby on 21/08/2025.
//

import SwiftUI

struct HourlyView: View {
    
    let hour: String
    let hourlyTemp: Int
    
    var body: some View {
        VStack(spacing: 15) {
            Text("\(hour)")
            Image(systemName: "cloud.fill")
            Text("\(hourlyTemp)º")
        }
        .foregroundStyle(.white)
        .padding()
        .background(.brown)
    }
}

#Preview {
    HourlyView(hour: "19", hourlyTemp: 18)
}
