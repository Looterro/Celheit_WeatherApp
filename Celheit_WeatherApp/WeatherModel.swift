//
//  WeatherModel.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 10/01/2023.
//


import Foundation

//The model that application uses to fit the API data

struct Weather: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let hourlyUnits: HourlyUnits
    let hourly: Hourly

    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case hourlyUnits = "hourly_units"
        case hourly
    }
    
    //MARK: - Sample Data
    
    static var SampleWeather: Weather = Bundle.main.decode(file: "testWeatherJSON.json")
    
    
}

struct Hourly: Codable {
    let time: [String]
    let temperature2M, apparentTemperature, precipitation: [Double]
    let cloudcover: [Int]

    private enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation, cloudcover
    }
}

struct HourlyUnits: Codable {
    let time, temperature2M, apparentTemperature, precipitation: String
    let cloudcover: String

    private enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation, cloudcover
    }
}
