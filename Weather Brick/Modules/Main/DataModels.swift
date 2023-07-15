//
//  DataModels.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 14.07.2023.
//

import Foundation

struct Weather: Codable {
    var main: String
}

struct Main: Codable {
    var temp: Double = 0.0
}

struct Sys: Codable {
    var country: String = ""
}

struct WeatherData: Codable {
    var weather: [Weather] = []
    var main: Main = Main()
    var sys: Sys = Sys()
    var name: String = ""
}
