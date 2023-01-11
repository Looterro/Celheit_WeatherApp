//
//  TempBoxView.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 11/01/2023.
//

import SwiftUI

struct TempBoxView: View {
    var weatherViewModel: ViewModel
    var farenheit: Bool = false
    
    var body: some View {

            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.white)
                    
                
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
        
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(lineWidth: 1)
                    
            }
            .frame(height: 150)

        
    }
}

//struct TempBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        TempBoxView(weatherViewModel: <#T##ViewModel#>)
//    }
//}