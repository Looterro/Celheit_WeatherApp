//
//  WeatherView.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 10/01/2023.
//

import SwiftUI
import HalfASheet

struct WeatherView: View {
    
    @StateObject private var lvm = LocationViewModel()
    @StateObject private var wvm = WeatherViewModel()
    
    @State var showingAllWeathers = false
    @State var locationName: String
    @State var showingTheWeather = false
    @State var isRefreshed: Bool = false

    var body: some View {
        NavigationView {
            
            if lvm.authorisationStatus.rawValue == 4 {
                
                VStack {
                    List {
                        
                        if showingTheWeather == true {
                        
                            VStack {
                            
                                Text("\(locationName) \(wvm.weather.timezoneAbbreviation)")
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                
                                HStack {
                                    
                                    TempBoxView(weatherViewModel: wvm, isRefreshed: $isRefreshed)
                                    
                                    
                                    TempBoxView(weatherViewModel: wvm, isRefreshed: $isRefreshed, farenheit: true)
                                        //.task(reloadRotationAnimation)
                                    
                                }
                                
                                cloudCover
                                
                                HourlyPredictionBoxView(weatherViewModel: wvm, isRefreshed: $isRefreshed)
                                    
                                
                                Divider()
                                
                                apiProvider
                                
                            }
                            .listRowBackground( wvm.isPouring() ? Color.gray.blur(radius: 150) : Color.blue.blur(radius: 150) )
                            .preferredColorScheme(!wvm.isDaytime(checkToday: true) || wvm.isPouring() ? .dark : .light)
                            .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
                        
                        } else {
                            
                            loadingCurrentLocationView
                            
                        }
                        
                    }
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
                    .task(delayTask)
                    .background( wvm.isPouring() ? Color.gray.opacity(0.3) : Color.blue.opacity(0.4) )
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        withAnimation(Animation.easeInOut(duration: 2)) {
                            isRefreshed = true
                            wvm.makeApiRequest(lat: wvm.latitude(), lon: wvm.longitude())
                        }
                    }
                    .sheet(isPresented: $showingAllWeathers) {
                        
                        ChangeLocationView(weatherViewModel: wvm, locationViewModel: lvm, locationName: $locationName)
                        
                    }

                }
                .onAppear {
                    getCurrentLocation()
                    //showingTheWeather = true
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        appTitle
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            changeWeatherLocationButton
                            
                            Spacer()
                            
                            getLocationButton
                        }
                        .foregroundColor(.white)
                        .padding()
                        .font(.footnote)
                    }
                    
                }

            } else {
                
                noLocationPermissionsPrompt
                    .onAppear {
                        getCurrentLocation()
                    }
                
            }
            
        }
        
    }
    
    private func delayTask() async {
        try? await Task.sleep(nanoseconds: 0_500_000_000)
        withAnimation() {
            showingTheWeather = true
        }
    }
    
    //MARK: - View components
    
    private var getLocationButton: some View {
        Button {
            getCurrentLocation()
        } label: {
            Image(systemName: "location.fill")
            Text("Use current location")
        }
    }
    
    private var changeWeatherLocationButton: some View {
        
        HStack{
            Button {
                showingAllWeathers.toggle()
            } label: {
                Image(systemName: "list.bullet")
                Text("Change location")
            }
        }
        
    }
    
    private var appTitle: some View {
        
            HStack {
                Text("Celheit App")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top)
            }
        
    }
    
    private var loadingCurrentLocationView: some View {
        
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer ()
                ProgressView()
                Spacer ()
            }
        }
        .listRowBackground(Color.blue.blur(radius: 150))
        .frame(height: 450)
        
    }
    
    private var noLocationPermissionsPrompt: some View {
        
        VStack {
            List {

                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        Spacer ()
                        VStack(alignment: .center) {
                            Text ("Please enable localization in the app settings")
                            ProgressView()
                                .padding()
                            Button() {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            } label: {
                                Text("Take me to settings")
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                        }
                        Spacer ()
                    }
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .listRowBackground(Color.blue.blur(radius: 150))
                .frame(height: 450)
 
            }
            .background(.blue.opacity(0.5))
            .scrollContentBackground(.hidden)

        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                appTitle
            }
        }

        
    }
    
    private var cloudCover: some View {
        
        VStack {
            Text("\(wvm.currentCloudCover().icon)")
                .font(.largeTitle)
            Group{
                Text("Cloud cover")
                Text("\(wvm.currentCloudCover().percentage) %")
            }
                .foregroundColor(.white)
        }
        
    }
    
    private var apiProvider: some View {
        Link("Weather data by Open-Meteo.com", destination: URL(string: "https://open-meteo.com/")!)
            .foregroundColor(.white)
            .font(.footnote)
        
    }
    
    //MARK: - Functions
    
    private func reloadRotationAnimation() async {
        try? await Task.sleep(nanoseconds: 5_500_000_000)
        isRefreshed = false
    }
    
    private func getCurrentLocation() {
            
            wvm.makeApiRequest(lat: Double(String(lvm.getLocation().1).prefix(5))!, lon: Double(String(lvm.getLocation().0).prefix(5))!)
            
            locationName = "Current Location"
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(locationName: "Cityname")
    }
}
