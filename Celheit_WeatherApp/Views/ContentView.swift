//
//  ContentView.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 10/01/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel(testMode: true)
//    let weather: Weather = Weather.SampleWeather
    let time = Date().ISO8601Format()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Krakow")
                Text("Time: \(vm.weather.hourly.time[vm.currentTimeindex() + 1])")
                Text("Temperature")
                Text("\(Int(vm.weather.hourly.temperature2M[vm.currentTimeindex() + 1])) \(vm.weather.hourlyUnits.apparentTemperature)")
                Text("Feels like")
                Text("\(Int(vm.weather.hourly.apparentTemperature[vm.currentTimeindex() + 1])) \(vm.weather.hourlyUnits.apparentTemperature)")
                Text("Cloud cover")
                Text("\(vm.weather.hourly.cloudcover[vm.currentTimeindex() + 1]) %")
                
                Divider()
                
                Link("Weather data by Open-Meteo.com", destination: URL(string: "https://open-meteo.com/")!)
                    .font(.footnote)
                
            }
            .navigationTitle("Celheit App")
            .refreshable {
                vm.makeApiRequest()
            }
        }
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("\(vm.currentTimeindex())")
//            Text("\(vm.weather.hourly.time[vm.currentTimeindex()])")
//            Text("\(vm.weather.hourly.apparentTemperature.first!) \(vm.weather.hourlyUnits.apparentTemperature)")
//        }
//        .onAppear {
//            print("\(time)")
//            print("\(vm.weather.hourly.time[vm.currentTimeindex()])")
//            print("\(vm.weather.hourly.time.first(where: { $0.prefix(13) == time.prefix(13) })!)")
//
//        }
//        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
