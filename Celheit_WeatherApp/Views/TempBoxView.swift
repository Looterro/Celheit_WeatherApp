//
//  TempBoxView.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 11/01/2023.
//

import SwiftUI

struct TempBoxView: View {
    @StateObject var weatherViewModel: WeatherViewModel
    @Binding var isRefreshed: Bool
    var farenheit: Bool = false
    
    var body: some View {

            ZStack {
                
                if weatherViewModel.isPouring() {
                    LinearGradient(gradient: Gradient(colors: weatherViewModel.isDaytime(checkToday: true) ? [Color.gray, Color.white] : [Color.black, Color(uiColor: UIColor.gray)] ), startPoint: .top, endPoint: .bottom)
                        .mask(RoundedRectangle(cornerRadius: 6))
                        .opacity(0.5)
                } else {
                    LinearGradient(gradient: Gradient(colors: weatherViewModel.isDaytime(checkToday: true) ? [Color.blue, Color.white] : [Color.blue, Color(uiColor: UIColor.black)] ), startPoint: .top, endPoint: .bottom)
                        .mask(RoundedRectangle(cornerRadius: 6))
                        .opacity(0.5)
                }
                    
                
                VStack {
                    
                    Spacer()
                    
                    Text(farenheit ? "\(weatherViewModel.currentTemperature(farenheit: true)) °F" : "\(weatherViewModel.currentTemperature()) °C")
                        .font(.largeTitle)
                    
                    Spacer()
                    Divider()
                    
                    Text("Feels like")
                        .font(.footnote)
                    
                    Text(farenheit ? "\(weatherViewModel.currentTemperature(farenheit: true, apparent: true)) °F" : "\(weatherViewModel.currentTemperature(apparent: true)) °C")
                        .font(.callout)
                        .padding(.bottom)
                    
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

//struct TempBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        TempBoxView(weatherViewModel: <#T##WeatherViewModel#>)
//    }
//}
