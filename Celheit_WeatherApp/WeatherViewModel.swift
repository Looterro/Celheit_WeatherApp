//
//  WeatherViewModel.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 10/01/2023.
//

import Foundation

final class WeatherViewModel: ObservableObject {
    
    @Published var weather: Weather = Weather.SampleWeather {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private let apiManager = ApiManager()
    
    init() {
        restoreFromUserDefaults()
    }
    
    //MARK: - Storing user defaults
    
    private var userDefaultsKey: String {
        "Weather"
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(weather), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey), let decodedWeather = try? JSONDecoder().decode(Weather.self, from: jsonData) {
            weather = decodedWeather
        }
    }
    
    //MARK: - Functions getting the api
    
    func makeApiRequest(lat: Double, lon: Double) {
    
        let baseUrl = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&hourly=temperature_2m,apparent_temperature,precipitation,rain,snowfall,cloudcover&daily=temperature_2m_max,sunrise,sunset,precipitation_hours&timezone=auto"
        
        //insert model of weather and the actual link. Weak self prevents from any memory leaks in api calls, nothing stays in the memory
        apiManager.getData(url: baseUrl, model: Weather.self) { [weak self] result in
            
            //weak self is an optional so this guard makes sure we dont have to handle that elsewhere
            guard let self = self else { return }
            
            
            DispatchQueue.main.async {
                
                //get the completion listener variable and switch on it. return quotes or error assigned to published variable
                switch(result) {
                case .success(let weather):
                    self.weather = weather
                case .failure(let error):
                    print(error)
                }
                
            }
            
        }
        
    }
    
    //MARK: - Other functions
    
    func currentTimeindex() -> Int {
        //get the iso date and hour that matches the currently picked timezone from the API string
        
        let adjustedTime = String(getTimeFormatted(time: Date(), timeZone: NSTimeZone(name: weather.timezone)! as TimeZone)).prefix(13)
        
        return Int(weather.hourly.time.firstIndex(where: { $0.prefix(13) == adjustedTime })!)
    }
    
    func currentDayIndex(addDays: Int = 0) -> Int {
        
        //get the iso format and find the current day index in data
        let adjustedDayformat = String(getTimeFormatted(time: Date(), timeZone: NSTimeZone(name: weather.timezone)! as TimeZone)).prefix(10)
        
        return Int(weather.daily.time.firstIndex(where: {$0.prefix(10) == adjustedDayformat})! + addDays)
    }
    
    func currentTemperature(farenheit: Bool = false, apparent: Bool = false, addHours: Int = 0) -> Int {
        
        let hourlyTemp = weather.hourly.temperature2M[currentTimeindex() + addHours]
        let apparentTemp = weather.hourly.apparentTemperature[currentTimeindex() + addHours]
        
        if farenheit == false {

            return Int(apparent ? apparentTemp : hourlyTemp)
            
        }
        
        return Int(Measurement(value: apparent ? apparentTemp : hourlyTemp, unit: UnitTemperature.celsius).converted(to: .fahrenheit).value)

    }
    
    func longitude() -> Double { Double(String(weather.longitude).prefix(5))! }
    func latitude() -> Double { Double(String(weather.latitude).prefix(5))! }
    
    func isDaytime(addHours: Int = 0, checkToday: Bool = false) -> Bool {
        let sunriseTime = weather.daily.sunrise[currentDayIndex()].suffix(5)
        let sunsetTime = weather.daily.sunset[currentDayIndex()].suffix(5)
        let givenTimeOfDay = String(weather.hourly.time[currentTimeindex() + addHours]).suffix(5)
        let currentTime = String(getTimeFormatted(time: Date(), timeZone: NSTimeZone(name: weather.timezone)! as TimeZone)).prefix(16).suffix(5)
        
        //String(weatherViewModel.weather.hourly.time[weatherViewModel.currentTimeindex() + number]).suffix(5)
        
        return checkToday ? sunriseTime < currentTime && sunsetTime > currentTime : sunriseTime < givenTimeOfDay && sunsetTime > givenTimeOfDay
    }
    
    func currentCloudCover(addHours: Int = 0, addDays: Int = 0) -> (percentage: Int, icon: String) {
        
        let cloudCover = weather.hourly.cloudcover[currentTimeindex() + addHours]
        
        //let sunriseTime = weather.daily.sunrise[currentDayIndex() + addDays].suffix(5)
        //let sunsetTime = weather.daily.sunset[currentDayIndex() + addDays].suffix(5)
        
        //let currentTime = String(getTimeFormatted(time: Date(), timeZone: NSTimeZone(name: weather.timezone)! as TimeZone)).prefix(16).suffix(5)
        
        //let isDay = sunriseTime < currentTime && sunsetTime > currentTime
        
        //print(weather.hourly.rain[currentTimeindex() + addHours ])
        
        let rain = weather.hourly.rain[currentTimeindex() + addHours]
        let shower = rain >= 2.0
        let smallShower = rain < 2.0 && rain > 0
        
        let snow = weather.hourly.snowfall[currentTimeindex() + addHours]
        let snowfall = snow > 0
        
        var cloudStatus = ""
        
        if cloudCover >= 75 {
            
            if smallShower {
                cloudStatus = "🌧️"
            } else if shower {
                cloudStatus = "⛈️"
            } else if snowfall {
                cloudStatus = "❄️"
            } else {
                cloudStatus = "☁️"
            }
                
        }
        if cloudCover >= 25 && cloudCover < 75 {
            
            if smallShower || shower || snowfall {
                cloudStatus = isDaytime(addHours: addHours) ?  "🌦️" : "🌧️🌙"
            } else {
                cloudStatus = isDaytime(addHours: addHours) ?  "⛅️" : "☁️🌙"
            }
            
        }
        if cloudCover < 25 {
            cloudStatus = isDaytime(addHours: addHours) ?  "☀️" : "🌙"
        }
        
        return (Int(cloudCover), cloudStatus)
    }
    
    func isPouring() -> Bool { return weather.hourly.precipitation[currentTimeindex()] > 0 }
    
    //MARK: - Helper functions
    
    func getTimeFormatted (time: Date, timeZone: TimeZone) -> String {
        let timeFormat = ISO8601DateFormatter()
        timeFormat.timeZone = timeZone
        return timeFormat.string(from: time)
    }
    
}
