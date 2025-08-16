//
//  DayView.swift
//  Weather
//
//  Created by Mark Darby on 14/08/2025.
//

import SwiftUI

struct DayView: View {
    var body: some View {
        VStack {
            Text("17")
                .foregroundStyle(.white)
                .bold()
            Image(systemName: "sun.max.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.multicolor)
            Text("25º")
                .foregroundStyle(.white)
                .bold()
        }
        .padding()
        .background(.blue)
    }
}

#Preview {
    DayView()
}
