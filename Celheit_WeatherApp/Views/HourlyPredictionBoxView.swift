//
//  HourlyPredictionBoxView.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 11/01/2023.
//

import SwiftUI

struct HourlyPredictionBoxView: View {
    @StateObject var weatherViewModel: WeatherViewModel
    @Binding var isRefreshed: Bool
    
    var body: some View {
        ZStack {
            
            if weatherViewModel.isPouring() {
                LinearGradient(gradient: Gradient(colors: weatherViewModel.isDaytime(checkToday: true) ? [Color.gray, Color.white] : [Color.black, Color(uiColor: UIColor.gray)] ), startPoint: .top, endPoint: .bottom)
                    .mask(RoundedRectangle(cornerRadius: 6))
                    .opacity(0.3)
            } else {
                LinearGradient(gradient: Gradient(colors: weatherViewModel.isDaytime(checkToday: true) ? [Color.blue, Color.white] : [Color.blue, Color(uiColor: UIColor.black)] ), startPoint: .top, endPoint: .bottom)
                    .mask(RoundedRectangle(cornerRadius: 6))
                    .opacity(0.3)
            }

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
            .foregroundColor(.white)
            
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(.clear)
            
            
        }
        .frame(height: 150)
        .cardify(isRefreshed: isRefreshed)
    }
    
}

//struct HourlyPredictionBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        HourlyPredictionBoxView()
//    }
//}
