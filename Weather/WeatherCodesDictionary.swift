//
//  WeatherCodesDictionary.swift
//  Weather
//
//  Created by Mark Darby on 24/08/2025.
//

import Foundation

let weatherInterpretationCodes: [Int: [Any]] = [0: ["Clear Sky", sunny, sunnySmall],
                                                 1: ["Mainly Clear", sunny, sunnySmall],
                                                 2: ["Partly Cloudy", partlyCloudy, partlyCloudySmall],
                                                 3: ["Overcast", overcast, overcastSmall],
                                                 45: ["Fog", fog, fogSmall],
                                                 48: ["Fog", fog, fogSmall],
                                                 51: ["Light Drizzle", drizzle, drizzleSmall],
                                                 53: ["Moderate Drizzle", drizzle, drizzleSmall],
                                                 55: ["Dense Drizzle", drizzle, drizzleSmall],
                                                 56: ["Light Freezing Drizzle", drizzle, drizzleSmall],
                                                 57: ["Intense Freezing Drizzle", drizzle, drizzleSmall],
                                                 61: ["Slight Rain", lightRain, lightRainSmall],
                                                 63: ["Moderate Rain", lightRain, lightRainSmall],
                                                 65: ["Heavy Rain", heavyRain, heavyRainSmall],
                                                 66: ["Light Freezing Rain", lightRain, lightRainSmall],
                                                 67: ["Heavy Freezing Rain", heavyRain, heavyRainSmall],
                                                 71: ["Slight Snow", snow, snowSmall],
                                                 73: ["Moderate Snow", snow, snowSmall],
                                                 75: ["Heavy Snow", snow, snowSmall],
                                                 77: ["Snow Grains", snow, snowSmall],
                                                 80: ["Slight Rain Showers", lightRain, lightRainSmall],
                                                 81: ["Moderate Rain Showers", lightRain, lightRainSmall],
                                                 82: ["Violent Rain Showers", heavyRain, heavyRainSmall],
                                                 85: ["Slight Snow Showers", snow, snowSmall],
                                                 86: ["Heavy Snow Showers", snow, snowSmall],
                                                 95: ["Slight Thunderstorm", thunderstorm, thunderstormSmall],
                                                 96: ["Thunderstorm with Slight Hail", thunderstorm, thunderstormSmall],
                                                 99: ["Thunderstorm with Heavy Hail", thunderstorm, thunderstormSmall],
                                                 ]

