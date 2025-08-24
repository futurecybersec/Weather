//
//  WeatherSymbols.swift
//  Weather
//
//  Created by Mark Darby on 24/08/2025.
//

import SwiftUI
import Foundation

var sunnySmall: some View {
    AnyView(
        VStack {
            Image(systemName: "sun.max.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.multicolor)
        }
    )
}

var sunny: some View {
    AnyView(
        Image(systemName: "sun.max.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .symbolRenderingMode(.multicolor)
    )
}

var partlyCloudySmall: some View {
    AnyView(
        VStack {
            Image(systemName: "cloud.sun.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .yellow)
        }
    )
}

var partlyCloudy: some View {
    AnyView(
        Image(systemName: "cloud.sun.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, .yellow)
    )
}

var overcastSmall: some View {
    AnyView(
        VStack {
            Image(systemName: "cloud.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
        }
    )
}

var overcast: some View {
    AnyView(
        Image(systemName: "cloud.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundStyle(.white)
    )
}

var fogSmall: some View {
    AnyView(
        VStack {
            Image(systemName: "cloud.fog.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .white)
        }
    )
}

var fog: some View {
    AnyView(
        Image(systemName: "cloud.fog.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, .white)
    )
}

var drizzleSmall: some View {
    AnyView(
        VStack {
            Image(systemName: "cloud.drizzle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white, .blue)
        }
    )
}

var drizzle: some View {
    AnyView(
        Image(systemName: "cloud.drizzle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundStyle(.white, .blue)
    )
}

var lightRainSmall: some View {
    AnyView(
        VStack {
            Image(systemName: "cloud.rain.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white, .blue)
        }
    )
}

var lightRain: some View {
    AnyView(
        Image(systemName: "cloud.rain.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundStyle(.white, .blue)
    )
}

var heavyRainSmall: some View {
    AnyView(
        VStack {
            Image(systemName: "cloud.heavyrain.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white, .blue)
        }
    )
}

var heavyRain: some View {
    AnyView(
        Image(systemName: "cloud.heavyrain.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundStyle(.white, .blue)
    )
}

var snowSmall: some View {
    AnyView(
        VStack {
            Image(systemName: "cloud.snow.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
        }
    )
}

var snow: some View {
    AnyView(
        Image(systemName: "cloud.snow.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundStyle(.white)
    )
}

var thunderstormSmall: some View {
    AnyView(
        VStack {
            Image(systemName: "cloud.bolt.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.gray, .yellow)
        }
    )
}

var thunderstorm: some View {
    AnyView(
        Image(systemName: "cloud.bolt.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.gray, .yellow)
    )
}
