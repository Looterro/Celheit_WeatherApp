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
    let dailyUnits: DailyUnits
    let daily: Daily

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case hourlyUnits = "hourly_units"
        case hourly
        case dailyUnits = "daily_units"
        case daily
    }
    
    //MARK: - Default Data for syncing the code
    
    static var SampleWeather: Weather = Weather(latitude: 0, longitude: 0, generationtimeMS: 0, utcOffsetSeconds: 0, timezone: "-", timezoneAbbreviation: "-", elevation: 0, hourlyUnits: HourlyUnits(time: "-", temperature2M: "-", apparentTemperature: "-", precipitation: "-", rain: "-", snowfall: "-", cloudcover: "-"), hourly: Hourly(time: [], temperature2M: [], apparentTemperature: [], precipitation: [], rain: [], snowfall: [], cloudcover: []), dailyUnits: DailyUnits(time: "-", temperature2MMax: "-", sunrise: "-", sunset: "-", precipitationHours: "-"), daily: Daily(time: [], temperature2MMax: [], sunrise: [], sunset: [], precipitationHours: []))
    
}

struct Daily: Codable {
    let time: [String]
    let temperature2MMax: [Double]
    let sunrise, sunset: [String]
    let precipitationHours: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case sunrise, sunset
        case precipitationHours = "precipitation_hours"
    }
}

struct DailyUnits: Codable {
    let time, temperature2MMax, sunrise, sunset: String
    let precipitationHours: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case sunrise, sunset
        case precipitationHours = "precipitation_hours"
    }
}

struct Hourly: Codable {
    let time: [String]
    let temperature2M, apparentTemperature, precipitation, rain: [Double]
    let snowfall: [Double]
    let cloudcover: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation, rain, snowfall, cloudcover
    }
}

struct HourlyUnits: Codable {
    let time, temperature2M, apparentTemperature, precipitation: String
    let rain, snowfall, cloudcover: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation, rain, snowfall, cloudcover
    }
}
