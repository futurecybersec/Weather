//
//  WeatherCodesDictionary.swift
//  Weather
//
//  Created by Mark Darby on 24/08/2025.
//

import Foundation


let weatherInterpretationCodes: [Int: [String]] = [0: ["Clear Sky", "sun.max.fill", "moon.stars.fill"],
                                                 1: ["Mainly Clear", "sun.max.fill", "moon.stars.fill"],
                                                 2: ["Partly Cloudy", "cloud.sun.fill", "cloud.moon.fill"],
                                                 3: ["Overcast", "cloud.fill", "cloud.fill"],
                                                 45: ["Fog", "cloud.fog.fill", "cloud.fog.fill"],
                                                 48: ["Fog", "cloud.fog.fill", "cloud.fog.fill"],
                                                 51: ["Light Drizzle", "cloud.drizzle.fill", "cloud.drizzle.fill"],
                                                 53: ["Moderate Drizzle", "cloud.drizzle.fill", "cloud.drizzle.fill"],
                                                 55: ["Dense Drizzle", "cloud.drizzle.fill", "cloud.drizzle.fill"],
                                                 56: ["Light Freezing Drizzle", "cloud.drizzle.fill", "cloud.drizzle.fill"],
                                                 57: ["Intense Freezing Drizzle", "cloud.drizzle.fill", "cloud.drizzle.fill"],
                                                 61: ["Slight Rain", "cloud.rain.fill", "cloud.rain.fill"],
                                                 63: ["Moderate Rain", "cloud.rain.fill", "cloud.rain.fill"],
                                                 65: ["Heavy Rain", "cloud.heavyrain.fill", "cloud.rain.fill"],
                                                 66: ["Light Freezing Rain", "cloud.rain.fill", "cloud.rain.fill"],
                                                 67: ["Heavy Freezing Rain", "cloud.heavyrain.fill", "cloud.heavyrain.fill"],
                                                 71: ["Slight Snow", "cloud.snow.fill", "cloud.snow.fill"],
                                                 73: ["Moderate Snow", "cloud.snow.fill", "cloud.snow.fill"],
                                                 75: ["Heavy Snow", "cloud.snow.fill", "cloud.snow.fill"],
                                                 77: ["Snow Grains", "cloud.snow.fill", "cloud.snow.fill"],
                                                 80: ["Slight Rain Showers", "cloud.rain.fill", "cloud.rain.fill"],
                                                 81: ["Moderate Rain Showers", "cloud.rain.fill", "cloud.rain.fill"],
                                                 82: ["Violent Rain Showers", "cloud.heavyrain.fill", "cloud.heavyrain.fill"],
                                                 85: ["Slight Snow Showers", "cloud.snow.fill", "cloud.snow.fill"],
                                                 86: ["Heavy Snow Showers", "cloud.snow.fill", "cloud.snow.fill"],
                                                 95: ["Slight Thunderstorm", "cloud.bolt.fill", "cloud.bolt.fill"],
                                                 96: ["Thunderstorm with Slight Hail", "cloud.bolt.fill", "cloud.bolt.fill"],
                                                 99: ["Thunderstorm with Heavy Hail", "cloud.bolt.fill", "cloud.bolt.fill"],
                                                 ]
