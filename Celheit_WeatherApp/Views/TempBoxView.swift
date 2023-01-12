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
                
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .mask(RoundedRectangle(cornerRadius: 6))
                    
                
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
