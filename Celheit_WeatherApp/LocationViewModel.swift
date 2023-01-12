//
//  LocationViewModel.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 11/01/2023.
//

import Foundation
import CoreLocationUI
import MapKit

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var locations = [Location]()
    
    private let apiManager = ApiManager()
    
    //MARK: - Functions getting the location api and the
    
    func makeFakeApiRequest() {
        self.locations = Location.SampleLocations
    }
    
    func makeApiRequest(locationName: String) {
    
        let baseUrl = "https://nominatim.openstreetmap.org/search?q=\(locationName)&format=json"
        
        //insert model of quote and the actual link. Weak self prevents from any memory leaks in api calls, nothing stays in the memory
        apiManager.getData(url: baseUrl, model: [Location].self) { [weak self] result in
            
            //weak self is an optional so this guard makes sure we dont have to handle that elsewhere
            guard let self = self else { return }
            
            
            DispatchQueue.main.async {
                
                //get the completion listener variable and switch on it. return quotes or error assigned to published variable
                switch(result) {
                case .success(let locations):
                    print(locations)
                    self.locations = locations
                case .failure(let error):
                    print(error)
                }
                
            }
            
        }
        
    }
    
    //MARK: - Get current location functions
    
    let locationManager = CLLocationManager()
    
    //if authorization status changes, get the current location
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func getLocation() -> (Double, Double) {
        
        let latitude = CLLocationManager().location?.coordinate.latitude
        let longitude = CLLocationManager().location?.coordinate.longitude
        
        if let latitude = latitude, let longitude = longitude {
            print((longitude, latitude))
            
            return (longitude, latitude)
        } else {
            return ((0.0, 0.0))
        }
    
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus
        authorisationStatus = manager.authorizationStatus
        
        if authStatus == .notDetermined || authStatus == .denied {
            locationManager.requestWhenInUseAuthorization()
            return 
        }
        
    }
    
}
