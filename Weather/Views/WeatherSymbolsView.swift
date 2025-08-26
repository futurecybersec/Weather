//
//  WeatherSymbolsView.swift
//  Weather
//
//  Created by Mark Darby on 25/08/2025.
//

import SwiftUI

struct WeatherSymbolsView: View {
    var body: some View {
        VStack {
            Image(systemName: "moon.stars.fill")
                .symbolRenderingMode(SymbolRenderingMode.palette)
                .foregroundStyle(.white, .yellow)
                .font(.system(size: 80))
            
            Image(systemName: "cloud.moon.fill")
                .symbolRenderingMode(SymbolRenderingMode.multicolor)
                .font(.system(size: 80))
            
            Image(systemName: "moon.fill")
                .symbolRenderingMode(SymbolRenderingMode.multicolor)
                .font(.system(size: 80))
            
            Image(systemName: "sunrise.fill")
                .font(.system(size: 80))
                .symbolRenderingMode(.multicolor)
            Image(systemName: "sunset.fill")
                .font(.system(size: 80))
                .symbolRenderingMode(.multicolor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
}

#Preview {
    WeatherSymbolsView()
}
