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
                    
                    Divider()
                    
                    Link("Weather data by Open-Meteo.com", destination: URL(string: "https://open-meteo.com/")!)
                        .font(.footnote)
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
            Text("Cloud cover")
            Text("\(vm.currentCloudCover()) %")
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
