//
//  HourlyPredictionBoxView.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 11/01/2023.
//

import SwiftUI

struct HourlyPredictionBoxView: View {
    var weatherViewModel: ViewModel
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.white)

            ScrollView(.horizontal) {
                HStack {
                    ForEach(1...12, id: \.self) { number in
                        VStack {
                            if number == 1 {
                                Text("Now")
                            } else {
                                Text(String(weatherViewModel.weather.hourly.time[weatherViewModel.currentTimeindex() + number]).suffix(5))
                            }
                            Text("\(weatherViewModel.currentCloudCover(addHours: number).icon)")
                            Text("\(weatherViewModel.currentTemperature(addHours:number)) °C")
                                .font(.callout)
                            Text("\(weatherViewModel.currentTemperature(farenheit: true, addHours:number)) °F")
                                .font(.callout)
                        }
                        .padding(8.0)
                        .font(.title3)
                    }
                }
                .padding()
            }
            
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(lineWidth: 1)
            
            
        }
        .frame(height: 150)
    }
    
}

//struct HourlyPredictionBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        HourlyPredictionBoxView()
//    }
//}
