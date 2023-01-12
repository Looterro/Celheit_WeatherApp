//
//  Celheit_WeatherAppApp.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 10/01/2023.
//

import SwiftUI

@main
struct Celheit_WeatherApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            WeatherView(locationName: "Cityname")
        }
    }
}
