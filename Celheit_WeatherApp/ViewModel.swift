//
//  ViewModel.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 10/01/2023.
//

import Foundation

final class ViewModel: ObservableObject {
    
    @Published var weather = Weather.SampleWeather
    
    private let baseUrl = "https://api.open-meteo.com/v1/forecast?latitude=50.06&longitude=19.94&hourly=temperature_2m,apparent_temperature,precipitation,cloudcover&timezone=auto"
    private let apiManager = ApiManager()
    
    init(testMode: Bool) {
        testMode ? makeFakeApiRequest() : makeApiRequest()
    }
    
    //MARK: - Functions getting the api
    
    func makeFakeApiRequest() {
        self.weather = Weather.SampleWeather
    }
    
    func makeApiRequest() {
        //insert model of quote and the actual link. Weak self prevents from any memory leaks in api calls, nothing stays in the memory
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
        //get the iso date and hour that matches the current time from the API string
        return Int(weather.hourly.time.firstIndex(where: { $0.prefix(13) == Date().ISO8601Format().prefix(13) })!)
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
    
    
}
