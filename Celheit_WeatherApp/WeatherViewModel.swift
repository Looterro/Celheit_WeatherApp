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
        
        let adjustedTime = String(getTimeFormatted(time: Date(), timeZone: NSTimeZone(abbreviation: weather.timezoneAbbreviation)! as TimeZone)).prefix(13)
        
        return Int(weather.hourly.time.firstIndex(where: { $0.prefix(13) == adjustedTime })!)
    }
    
    func currentTemperature(farenheit: Bool = false, apparent: Bool = false, addHours: Int = 0) -> Int {
        
        let hourlyTemp = weather.hourly.temperature2M[currentTimeindex() + addHours]
        let apparentTemp = weather.hourly.apparentTemperature[currentTimeindex() + addHours]
        
        if farenheit == false {

            return Int(apparent ? apparentTemp : hourlyTemp)
            
        }
        
        return Int(Measurement(value: apparent ? apparentTemp : hourlyTemp, unit: UnitTemperature.celsius).converted(to: .fahrenheit).value)

    }
    
    func currentCloudCover(addHours: Int = 0) -> (percentage: Int, icon: String) {
        
        let cloudCover = weather.hourly.cloudcover[currentTimeindex() + addHours]
        //let time = String(weather.hourly.time[currentTimeindex() + addHours]).suffix(5) | to add sunset/sunrise emojis
        
        var emoji = ""
        
        if cloudCover > 75 {
            emoji = "☁️"
        }
        if cloudCover >= 25 && cloudCover < 75 {
            emoji = "⛅️"
        }
        if cloudCover < 25 {
            emoji = "☀️"
        }
        
        return (Int(cloudCover), emoji)
    }
    
    //MARK: - Helper functions
    
    func getTimeFormatted (time: Date, timeZone: TimeZone) -> String {
        let timeFormat = ISO8601DateFormatter()
        timeFormat.timeZone = timeZone
        return timeFormat.string(from: time)
    }
    
}
