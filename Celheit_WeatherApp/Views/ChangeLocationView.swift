//
//  ChangeLocationView.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 11/01/2023.
//

import SwiftUI

struct ChangeLocationView: View {
    @StateObject var weatherViewModel: WeatherViewModel
    @StateObject var locationViewModel: LocationViewModel
    @Binding var locationName: String
    
    @State var text = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        List {
            
            TextField("Change city", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    //search the api
                    locationViewModel.makeApiRequest(locationName: text.lowercased().replacingOccurrences(of: " ", with: "+"))
                }
            
            apiProvider
            
            //ForEaching the results
            ForEach(locationViewModel.locations) { location in
                Text(location.displayName)
                    .onTapGesture {
                        locationName = location.displayName
                        weatherViewModel.makeApiRequest(lat: Double(String(location.lat).prefix(5))!, lon: Double(String(location.lon).prefix(5))!)
                        dismiss()
                    }
            }
            
        }
        
    }
    
    var apiProvider: some View {
        Link("Location data search by nominatim.org", destination: URL(string: "https://nominatim.org/")!)
            .foregroundColor(.blue)
            .font(.footnote)
        
    }
    
}


