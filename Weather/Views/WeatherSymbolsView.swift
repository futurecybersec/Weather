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
            Image(systemName: "sun.max.fill")
                .symbolRenderingMode(SymbolRenderingMode.multicolor)
                .font(.system(size: 80))
            
            Image(systemName: "cloud.sun.fill")
                .symbolRenderingMode(SymbolRenderingMode.multicolor)
                .font(.system(size: 80))
            
            Image(systemName: "cloud.fill")
                .symbolRenderingMode(SymbolRenderingMode.multicolor)
                .font(.system(size: 80))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
}

#Preview {
    WeatherSymbolsView()
}
