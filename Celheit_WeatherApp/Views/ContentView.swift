//
//  ContentView.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 10/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ViewModel(testMode: true)
    
    var body: some View {
        NavigationView {
            
            List {
                VStack {
                    Text("Krakow \(vm.weather.timezone)")
                    
                    HStack {
                        
                        TempBoxView(weatherViewModel: vm)
                        
                        TempBoxView(weatherViewModel: vm, farenheit: true)

                    }
                    
                    cloudCover
                    
                    HourlyPredictionBoxView(weatherViewModel: vm)
                    
                    Divider()
                    
                    apiProvider
                    
                }
            }
            .navigationTitle("Celheit App")
            .refreshable {
                vm.makeApiRequest()
            }
        }
    }
    
    var cloudCover: some View {
        
        VStack {
            Text("\(vm.currentCloudCover().icon)")
                .font(.largeTitle)
            Text("Cloud cover")
            Text("\(vm.currentCloudCover().percentage) %")
        }
        
    }
    
    var apiProvider: some View {
        Link("Weather data by Open-Meteo.com", destination: URL(string: "https://open-meteo.com/")!)
            .font(.footnote)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
